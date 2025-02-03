import Flutter
import UIKit
import UserNotifications

public class EasyNotificationsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "easy_notifications", binaryMessenger: registrar.messenger())
        let instance = EasyNotificationsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "showNotification":
            if let args = call.arguments as? [String: Any],
               let title = args["title"] as? String,
               let body = args["body"] as? String {
                showNotification(title: title, body: body)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            }
        case "areNotificationsEnabled":
            checkNotificationStatus { enabled in
                result(enabled)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func checkNotificationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
}
