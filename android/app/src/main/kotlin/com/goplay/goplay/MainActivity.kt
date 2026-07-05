package com.goplay.goplay

import android.app.PictureInPictureParams
import android.os.Build
import android.os.Bundle
import android.util.Rational
import androidx.media3.common.util.UnstableApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

@UnstableApi
class MainActivity : FlutterActivity() {
    private var pipChannel: MethodChannel? = null
    private var isPlayerActive = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register the native ExoPlayer PlatformView
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "com.goplay/native_player",
                NativePlayerViewFactory(flutterEngine.dartExecutor.binaryMessenger)
            )

        pipChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.goplay/pip")
        pipChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "enterPiP" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        try {
                            val builder = PictureInPictureParams.Builder()
                            builder.setAspectRatio(Rational(16, 9))
                            val entered = enterPictureInPictureMode(builder.build())
                            result.success(entered)
                        } catch (e: Exception) {
                            result.error("PIP_FAILED", e.message, null)
                        }
                    } else {
                        result.error("UNSUPPORTED", "PiP not supported on this version of Android", null)
                    }
                }
                "setPlayerActive" -> {
                    isPlayerActive = call.arguments as? Boolean ?: false
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (isPlayerActive && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                val builder = PictureInPictureParams.Builder()
                builder.setAspectRatio(Rational(16, 9))
                enterPictureInPictureMode(builder.build())
            } catch (e: Exception) {
                // Ignore
            }
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: android.content.res.Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        pipChannel?.invokeMethod("onPiPModeChanged", isInPictureInPictureMode)
    }
}
