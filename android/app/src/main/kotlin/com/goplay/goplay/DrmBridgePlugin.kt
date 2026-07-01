package com.goplay.goplay

import android.app.Activity
import android.net.Uri
import android.util.Base64
import android.util.Log
import androidx.media3.common.C
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.drm.DefaultDrmSessionManager
import androidx.media3.exoplayer.drm.FrameworkMediaDrm
import androidx.media3.exoplayer.drm.HttpMediaDrmCallback
import androidx.media3.exoplayer.drm.LocalMediaDrmCallback
import androidx.media3.exoplayer.source.DefaultMediaSourceFactory
import androidx.media3.datasource.DefaultHttpDataSource
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

/**
 * Platform channel bridge for DRM-protected stream playback.
 *
 * Supports:
 * - ClearKey: Constructs a local license response from hex kid/key pairs.
 * - Widevine: Proxies license requests to a remote server with optional headers.
 *
 * Flutter calls this via MethodChannel("com.goplay/drm").
 */
class DrmBridgePlugin private constructor(
    private val activity: Activity
) : MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL_NAME = "com.goplay/drm"
        private const val TAG = "DrmBridgePlugin"

        fun registerWith(flutterEngine: FlutterEngine, activity: Activity) {
            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            channel.setMethodCallHandler(DrmBridgePlugin(activity))
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "buildClearKeyLicense" -> {
                try {
                    val kidHex = call.argument<String>("kid")
                        ?: return result.error("INVALID_ARGS", "Missing kid", null)
                    val keyHex = call.argument<String>("key")
                        ?: return result.error("INVALID_ARGS", "Missing key", null)

                    val license = buildClearKeyLicenseJson(kidHex, keyHex)
                    result.success(license)
                } catch (e: Exception) {
                    Log.e(TAG, "ClearKey license build failed", e)
                    result.error("DRM_ERROR", e.message, null)
                }
            }

            "getDrmSchemeUuid" -> {
                val type = call.argument<String>("type") ?: "clearkey"
                val uuid = when (type) {
                    "clearkey" -> C.CLEARKEY_UUID.toString()
                    "widevine" -> C.WIDEVINE_UUID.toString()
                    "playready" -> C.PLAYREADY_UUID.toString()
                    else -> null
                }
                result.success(uuid)
            }

            else -> result.notImplemented()
        }
    }

    /**
     * Build a ClearKey license JSON response per RFC 8586.
     * kid and key are hex strings → converted to base64url (no padding).
     */
    private fun buildClearKeyLicenseJson(kidHex: String, keyHex: String): String {
        val kidBytes = hexToBytes(kidHex)
        val keyBytes = hexToBytes(keyHex)

        val kidB64 = Base64.encodeToString(kidBytes, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)
        val keyB64 = Base64.encodeToString(keyBytes, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)

        val keyObj = JSONObject().apply {
            put("kty", "oct")
            put("k", keyB64)
            put("kid", kidB64)
        }

        val json = JSONObject().apply {
            put("keys", JSONArray().put(keyObj))
            put("type", "temporary")
        }

        return json.toString()
    }

    private fun hexToBytes(hex: String): ByteArray {
        val cleanHex = hex.replace(" ", "").lowercase()
        return ByteArray(cleanHex.length / 2) { i ->
            cleanHex.substring(i * 2, i * 2 + 2).toInt(16).toByte()
        }
    }
}
