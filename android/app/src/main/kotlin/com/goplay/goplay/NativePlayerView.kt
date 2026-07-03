package com.goplay.goplay

import android.content.Context
import android.net.Uri
import android.util.Base64
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import androidx.media3.common.C
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.util.UnstableApi
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.drm.DefaultDrmSessionManager
import androidx.media3.exoplayer.drm.LocalMediaDrmCallback
import androidx.media3.exoplayer.drm.FrameworkMediaDrm
import androidx.media3.exoplayer.drm.HttpMediaDrmCallback
import androidx.media3.exoplayer.hls.HlsMediaSource
import androidx.media3.exoplayer.dash.DashMediaSource
import androidx.media3.exoplayer.source.DefaultMediaSourceFactory
import androidx.media3.exoplayer.source.MediaSource
import androidx.media3.ui.PlayerView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.StandardMessageCodec
import org.json.JSONArray
import org.json.JSONObject

/**
 * Native ExoPlayer/Media3 PlatformView for Flutter.
 *
 * Provides:
 * - Direct HLS/DASH playback with custom HTTP headers (Referer, User-Agent, etc.)
 * - ClearKey DRM (local license from kid/key hex pairs)
 * - Widevine DRM (remote license server with optional headers)
 * - Native hardware decoding via MediaCodec
 * - Automatic header propagation to all segment/key requests
 */
@UnstableApi
class NativePlayerView(
    private val context: Context,
    private val viewId: Int,
    private val messenger: BinaryMessenger,
    creationParams: Map<String, Any?>?
) : PlatformView, MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "NativePlayerView"
        private const val CHANNEL_PREFIX = "com.goplay/native_player_"
    }

    private val container: FrameLayout = FrameLayout(context)
    private val playerView: PlayerView = PlayerView(context)
    private var player: ExoPlayer? = null
    private val methodChannel: MethodChannel

    init {
        // Setup PlayerView
        playerView.useController = false // Flutter handles its own controls
        playerView.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        container.addView(playerView)

        // Setup MethodChannel for this view instance
        methodChannel = MethodChannel(messenger, "$CHANNEL_PREFIX$viewId")
        methodChannel.setMethodCallHandler(this)

        // If creation params were provided, initialize immediately
        if (creationParams != null) {
            val url = creationParams["url"] as? String
            if (!url.isNullOrBlank()) {
                initializePlayer(creationParams)
            }
        }
    }

    override fun getView(): View = container

    override fun dispose() {
        Log.d(TAG, "Disposing NativePlayerView $viewId")
        methodChannel.setMethodCallHandler(null)
        player?.release()
        player = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "play" -> {
                val args = call.arguments as? Map<*, *>
                if (args != null) {
                    @Suppress("UNCHECKED_CAST")
                    initializePlayer(args as Map<String, Any?>)
                    result.success(true)
                } else {
                    result.error("INVALID_ARGS", "Missing arguments", null)
                }
            }
            "pause" -> {
                player?.pause()
                result.success(true)
            }
            "resume" -> {
                player?.play()
                result.success(true)
            }
            "stop" -> {
                player?.stop()
                result.success(true)
            }
            "setVolume" -> {
                val volume = (call.arguments as? Double)?.toFloat() ?: 1.0f
                player?.volume = volume
                result.success(true)
            }
            "getState" -> {
                result.success(mapOf(
                    "isPlaying" to (player?.isPlaying == true),
                    "playbackState" to (player?.playbackState ?: Player.STATE_IDLE),
                    "duration" to (player?.duration ?: 0L),
                    "position" to (player?.currentPosition ?: 0L)
                ))
            }
            "dispose" -> {
                player?.release()
                player = null
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    /**
     * Initialize ExoPlayer with the given stream configuration.
     *
     * @param config Map containing:
     *   - "url": Stream URL (HLS .m3u8 or DASH .mpd)
     *   - "headers": Map<String, String> of HTTP headers
     *   - "drm_type": "clearkey" | "widevine" | null
     *   - "drm_kid": ClearKey KID hex string
     *   - "drm_key": ClearKey Key hex string
     *   - "drm_license_url": Widevine license server URL
     *   - "drm_license_headers": Map<String, String> for license requests
     */
    private fun initializePlayer(config: Map<String, Any?>) {
        // Release any existing player
        player?.release()

        val url = config["url"] as? String ?: return
        Log.d(TAG, "Initializing player with config: $config")

        // --- Build HTTP DataSource Factory with custom headers ---
        val httpFactory = DefaultHttpDataSource.Factory()
            .setConnectTimeoutMs(15_000)
            .setReadTimeoutMs(15_000)
            .setAllowCrossProtocolRedirects(true)

        @Suppress("UNCHECKED_CAST")
        val headers = config["headers"] as? Map<String, String>
        if (!headers.isNullOrEmpty()) {
            httpFactory.setDefaultRequestProperties(headers)
            Log.d(TAG, "Custom headers set: ${headers.keys}")
        }

        // Set a default User-Agent if not already specified
        val ua = headers?.entries?.firstOrNull { it.key.equals("User-Agent", ignoreCase = true) }?.value
        if (ua != null) {
            httpFactory.setUserAgent(ua)
        } else {
            httpFactory.setUserAgent("Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 Chrome/120.0.0.0 Mobile Safari/537.36")
        }

        // --- Build DRM Session Manager if needed ---
        val drmType = config["drm_type"] as? String
        val drmSessionManager = when (drmType) {
            "clearkey" -> buildClearKeyDrm(config)
            "widevine" -> buildWidevineDrm(config, httpFactory)
            else -> null
        }

        // --- Build ExoPlayer ---
        val playerBuilder = ExoPlayer.Builder(context)

        if (drmSessionManager != null) {
            val mediaSourceFactory = DefaultMediaSourceFactory(httpFactory)
            mediaSourceFactory.setDrmSessionManagerProvider { drmSessionManager }
            playerBuilder.setMediaSourceFactory(mediaSourceFactory)
        } else {
            playerBuilder.setMediaSourceFactory(DefaultMediaSourceFactory(httpFactory))
        }

        val exoPlayer = playerBuilder.build()
        player = exoPlayer
        playerView.player = exoPlayer

        // --- Build MediaItem ---
        val uri = Uri.parse(url)
        val mediaItemBuilder = MediaItem.Builder().setUri(uri)

        // Auto-detect MIME type from URL
        val urlLower = url.lowercase()
        when {
            urlLower.contains(".mpd") -> mediaItemBuilder.setMimeType(MimeTypes.APPLICATION_MPD)
            urlLower.contains(".m3u8") -> mediaItemBuilder.setMimeType(MimeTypes.APPLICATION_M3U8)
        }

        // Configure DRM on the MediaItem if needed
        if (drmType == "clearkey" || drmType == "widevine") {
            val drmUuid = when (drmType) {
                "clearkey" -> C.CLEARKEY_UUID
                "widevine" -> C.WIDEVINE_UUID
                else -> null
            }
            if (drmUuid != null) {
                val drmConfig = MediaItem.DrmConfiguration.Builder(drmUuid)
                if (drmType == "clearkey") {
                    // ExoPlayer handles ClearKey via the DrmSessionManager we configured
                }
                if (drmType == "widevine") {
                    val licenseUrl = config["drm_license_url"] as? String
                    if (licenseUrl != null) {
                        drmConfig.setLicenseUri(licenseUrl)
                    }
                    @Suppress("UNCHECKED_CAST")
                    val licenseHeaders = config["drm_license_headers"] as? Map<String, String>
                    if (!licenseHeaders.isNullOrEmpty()) {
                        drmConfig.setLicenseRequestHeaders(licenseHeaders)
                    }
                }
                mediaItemBuilder.setDrmConfiguration(drmConfig.build())
            }
        }

        val mediaItem = mediaItemBuilder.build()

        // --- Add error listener ---
        exoPlayer.addListener(object : Player.Listener {
            private var fallbackStage = 0 // Stages: 0 = none, 1 = audio disabled, 2 = video size SD, 3 = audio disabled + video size SD

            override fun onPlayerError(error: PlaybackException) {
                Log.e(TAG, "Playback error: ${error.errorCodeName} - ${error.message}", error)
                
                val errorMsg = error.message ?: ""
                val causeMsg = error.cause?.message ?: ""
                val isDrmError = (error.errorCode in 6000..6999) ||
                                 error.errorCodeName.startsWith("ERROR_CODE_DRM") ||
                                 errorMsg.contains("DRM", ignoreCase = true) ||
                                 errorMsg.contains("decrypt", ignoreCase = true) ||
                                 causeMsg.contains("decryption", ignoreCase = true) ||
                                 causeMsg.contains("crypto", ignoreCase = true)
                
                if (isDrmError && fallbackStage < 3) {
                    val isAudioFailing = errorMsg.contains("audio", ignoreCase = true) || 
                                         error.errorCodeName.contains("AUDIO")
                    val isVideoFailing = errorMsg.contains("video", ignoreCase = true) || 
                                         error.errorCodeName.contains("VIDEO")

                    try {
                        val currentParameters = exoPlayer.trackSelectionParameters
                        val builder = currentParameters.buildUpon()

                        if (fallbackStage == 0) {
                            if (isAudioFailing) {
                                Log.w(TAG, "DRM audio error. Stage 1 fallback: Disabling audio track.")
                                builder.setTrackTypeDisabled(C.TRACK_TYPE_AUDIO, true)
                                fallbackStage = 1
                            } else if (isVideoFailing) {
                                Log.w(TAG, "DRM video error. Stage 2 fallback: Restricting video to SD.")
                                builder.setMaxVideoSizeSd()
                                fallbackStage = 2
                            } else {
                                Log.w(TAG, "General DRM error. Stage 2 fallback: Restricting video to SD first.")
                                builder.setMaxVideoSizeSd()
                                fallbackStage = 2
                            }
                        } else if (fallbackStage == 1) {
                            // Audio was disabled, but still got error, so video must also be failing
                            Log.w(TAG, "DRM error persists. Stage 3 fallback: Disabling audio and restricting video to SD.")
                            builder.setTrackTypeDisabled(C.TRACK_TYPE_AUDIO, true)
                            builder.setMaxVideoSizeSd()
                            fallbackStage = 3
                        } else if (fallbackStage == 2) {
                            // Video size was restricted to SD, but still got error, so audio must also be failing
                            Log.w(TAG, "DRM error persists. Stage 3 fallback: Disabling audio and restricting video to SD.")
                            builder.setTrackTypeDisabled(C.TRACK_TYPE_AUDIO, true)
                            builder.setMaxVideoSizeSd()
                            fallbackStage = 3
                        }

                        exoPlayer.trackSelectionParameters = builder.build()
                        exoPlayer.prepare()
                        exoPlayer.play()
                        return
                    } catch (fallbackEx: Exception) {
                        Log.e(TAG, "Failed to apply DRM fallback stage $fallbackStage", fallbackEx)
                    }
                }

                methodChannel.invokeMethod("onError", mapOf(
                    "code" to error.errorCode,
                    "message" to (error.message ?: "Unknown playback error")
                ))
            }

            override fun onPlaybackStateChanged(playbackState: Int) {
                val stateName = when (playbackState) {
                    Player.STATE_IDLE -> "idle"
                    Player.STATE_BUFFERING -> "buffering"
                    Player.STATE_READY -> "ready"
                    Player.STATE_ENDED -> "ended"
                    else -> "unknown"
                }
                Log.d(TAG, "Playback state: $stateName")
                methodChannel.invokeMethod("onStateChanged", mapOf(
                    "state" to stateName,
                    "isPlaying" to exoPlayer.isPlaying
                ))
            }

            override fun onIsPlayingChanged(isPlaying: Boolean) {
                methodChannel.invokeMethod("onStateChanged", mapOf(
                    "state" to if (isPlaying) "playing" else "paused",
                    "isPlaying" to isPlaying
                ))
            }
        })

        // --- Start playback ---
        exoPlayer.setMediaItem(mediaItem)
        exoPlayer.prepare()
        exoPlayer.playWhenReady = true
        Log.d(TAG, "Player prepared and starting playback")
    }

    /**
     * Build ClearKey DRM session manager from hex kid/key.
     */
    private fun buildClearKeyDrm(config: Map<String, Any?>): DefaultDrmSessionManager? {
        val keysArray = JSONArray()

        val clearKeys = config["drm_clearkeys"] as? Map<*, *>
        if (!clearKeys.isNullOrEmpty()) {
            for ((kidRaw, keyRaw) in clearKeys) {
                val kidHex = kidRaw as? String
                val keyHex = keyRaw as? String
                if (kidHex != null && keyHex != null) {
                    try {
                        val kidBytes = hexToBytes(kidHex)
                        val keyBytes = hexToBytes(keyHex)
                        val kidB64 = Base64.encodeToString(kidBytes, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)
                        val keyB64 = Base64.encodeToString(keyBytes, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)

                        val keyObj = JSONObject().apply {
                            put("kty", "oct")
                            put("k", keyB64)
                            put("kid", kidB64)
                        }
                        keysArray.put(keyObj)
                    } catch (e: Exception) {
                        Log.e(TAG, "Failed to parse kid/key pair: kid=$kidHex", e)
                    }
                }
            }
        } else {
            val kidHex = config["drm_kid"] as? String
            val keyHex = config["drm_key"] as? String
            if (kidHex != null && keyHex != null) {
                try {
                    val kidBytes = hexToBytes(kidHex)
                    val keyBytes = hexToBytes(keyHex)
                    val kidB64 = Base64.encodeToString(kidBytes, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)
                    val keyB64 = Base64.encodeToString(keyBytes, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)

                    val keyObj = JSONObject().apply {
                        put("kty", "oct")
                        put("k", keyB64)
                        put("kid", kidB64)
                    }
                    keysArray.put(keyObj)
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to parse single kid/key: kid=$kidHex", e)
                }
            }
        }

        if (keysArray.length() == 0) {
            Log.w(TAG, "No ClearKey keys found in config")
            return null
        }

        return try {
            val licenseJson = JSONObject().apply {
                put("keys", keysArray)
                put("type", "temporary")
            }

            val licenseBytes = licenseJson.toString().toByteArray(Charsets.UTF_8)
            val callback = LocalMediaDrmCallback(licenseBytes)

            DefaultDrmSessionManager.Builder()
                .setUuidAndExoMediaDrmProvider(C.CLEARKEY_UUID, FrameworkMediaDrm.DEFAULT_PROVIDER)
                .setMultiSession(true)
                .build(callback)
                .also {
                    Log.d(TAG, "ClearKey DRM configured with ${keysArray.length()} keys. Enabled multi-session.")
                }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to build ClearKey DRM", e)
            null
        }
    }

    /**
     * Build Widevine DRM session manager with a remote license server.
     */
    private fun buildWidevineDrm(
        config: Map<String, Any?>,
        httpFactory: DefaultHttpDataSource.Factory
    ): DefaultDrmSessionManager? {
        val licenseUrl = config["drm_license_url"] as? String ?: return null

        return try {
            val callback = HttpMediaDrmCallback(licenseUrl, httpFactory)

            @Suppress("UNCHECKED_CAST")
            val licenseHeaders = config["drm_license_headers"] as? Map<String, String>
            licenseHeaders?.forEach { (key, value) ->
                callback.setKeyRequestProperty(key, value)
            }

            DefaultDrmSessionManager.Builder()
                .setUuidAndExoMediaDrmProvider(C.WIDEVINE_UUID, FrameworkMediaDrm.DEFAULT_PROVIDER)
                .build(callback)
                .also {
                    Log.d(TAG, "Widevine DRM configured: licenseUrl=$licenseUrl")
                }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to build Widevine DRM", e)
            null
        }
    }

    private fun hexToBytes(hex: String): ByteArray {
        val cleanHex = hex.replace(" ", "").lowercase()
        return ByteArray(cleanHex.length / 2) { i ->
            cleanHex.substring(i * 2, i * 2 + 2).toInt(16).toByte()
        }
    }
}

/**
 * Factory for creating NativePlayerView instances from Flutter.
 */
@UnstableApi
class NativePlayerViewFactory(
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        @Suppress("UNCHECKED_CAST")
        val creationParams = args as? Map<String, Any?>
        return NativePlayerView(context, viewId, messenger, creationParams)
    }
}
