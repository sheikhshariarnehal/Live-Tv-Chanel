package com.goplay.goplay

import android.os.Bundle
import androidx.media3.common.util.UnstableApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

@UnstableApi
class MainActivity : FlutterActivity() {
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
    }
}
