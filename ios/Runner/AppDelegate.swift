import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // "uz.azam.zikr/tizim": iOS'da faqat sozlamalarni ochish (ovoz tugmasi Android'da).
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ZikrTizim") {
      let kanal = FlutterMethodChannel(name: "uz.azam.zikr/tizim", binaryMessenger: registrar.messenger())
      kanal.setMethodCallHandler { call, result in
        switch call.method {
        case "bildirishnomaSozlamalari":
          if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
          }
          result(nil)
        case "ovozTugmasiniUshlash":
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }
}
