package com.example.boro_android

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pushChannel: MethodChannel? = null
    private var pendingPushPayload: Map<String, String>? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        BoroFirebaseMessagingService.createNotificationChannel(this)
        pendingPushPayload = extractPushPayload(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        pushChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "boro/push",
        )
        pushChannel?.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                "getInitialPushPayload" -> {
                    result.success(pendingPushPayload)
                    pendingPushPayload = null
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val payload = extractPushPayload(intent) ?: return
        pendingPushPayload = payload
        pushChannel?.invokeMethod("onPushOpened", payload)
    }

    private fun extractPushPayload(intent: Intent?): Map<String, String>? {
        val extras = intent?.extras ?: return null
        if (!extras.containsKey(BoroFirebaseMessagingService.KEY_PUSH_OPENED)) return null

        val payload = linkedMapOf<String, String>()
        for (key in extras.keySet()) {
            if (key.startsWith(BoroFirebaseMessagingService.KEY_PUSH_PREFIX)) {
                val mappedKey = key.removePrefix(BoroFirebaseMessagingService.KEY_PUSH_PREFIX)
                val value = extras.get(key)?.toString() ?: continue
                payload[mappedKey] = value
            }
        }
        return if (payload.isEmpty()) null else payload
    }
}
