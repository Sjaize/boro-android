package com.example.boro_android

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class BoroFirebaseMessagingService : FirebaseMessagingService() {
    override fun onCreate() {
        super.onCreate()
        createNotificationChannel(applicationContext)
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(KEY_NATIVE_FCM_TOKEN, token)
            .apply()
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        // 포그라운드 알림 표시는 Flutter(flutter_local_notifications)가 담당.
        // 백그라운드/종료 상태에서는 notification payload가 있으면 Android가 자동 표시.
        // 여기서 추가로 띄우면 중복 알림이 발생하므로 표시하지 않음.
    }

    companion object {
        const val CHANNEL_ID = "boro_notifications"
        const val CHANNEL_NAME = "BORO Notifications"
        const val CHANNEL_DESCRIPTION = "BORO push notifications"
        const val PREFS_NAME = "boro_push_prefs"
        const val KEY_NATIVE_FCM_TOKEN = "native_fcm_token"
        const val KEY_PUSH_OPENED = "push_opened"
        const val KEY_PUSH_PREFIX = "push_"

        fun createNotificationChannel(context: Context) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

            val manager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = CHANNEL_DESCRIPTION
            }
            manager.createNotificationChannel(channel)
        }
    }
}
