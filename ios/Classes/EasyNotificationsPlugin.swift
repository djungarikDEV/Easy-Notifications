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
                showNotification(title: title, body: body, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", 
                                  message: "Invalid arguments for showNotification", 
                                  details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func showNotification(title: String, body: String, result: @escaping FlutterResult) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, 
                                          content: content, 
                                          trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    result(FlutterError(code: "NOTIFICATION_ERROR", 
                                      message: error.localizedDescription, 
                                      details: nil))
                } else {
                    result(nil)
                }
            }
        }
    }
}
