package uz.azam.zikr

import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Flutter bilan "uz.azam.zikr/tizim" kanali:
 *  - ovozTugmasiniUshlash(bool): yoqilganda ovoz balandligi tugmalari sanaydi
 *    (Flutter'ga "ovozTugmasi" yuboriladi, tizim ovoz balandligi o'zgarmaydi);
 *  - bildirishnomaSozlamalari: ilovaning bildirishnoma sozlamalarini ochadi.
 */
class MainActivity : FlutterActivity() {
    private var kanal: MethodChannel? = null
    private var ovozTugmasiniUshlash = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        kanal = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "uz.azam.zikr/tizim").apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "ovozTugmasiniUshlash" -> {
                        ovozTugmasiniUshlash = call.arguments as? Boolean ?: false
                        result.success(null)
                    }
                    "bildirishnomaSozlamalari" -> {
                        bildirishnomaSozlamalariniOch()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        val ovoz = event.keyCode == KeyEvent.KEYCODE_VOLUME_UP || event.keyCode == KeyEvent.KEYCODE_VOLUME_DOWN
        if (ovozTugmasiniUshlash && ovoz) {
            // Bosib turilganda takrorlanmasin: faqat birinchi bosish sanaladi.
            if (event.action == KeyEvent.ACTION_DOWN && event.repeatCount == 0) {
                kanal?.invokeMethod("ovozTugmasi", null)
            }
            return true // tizim ovoz balandligini o'zgartirmaydi
        }
        return super.dispatchKeyEvent(event)
    }

    private fun bildirishnomaSozlamalariniOch() {
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
        } else {
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                .setData(android.net.Uri.fromParts("package", packageName, null))
        }
        startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
    }
}
