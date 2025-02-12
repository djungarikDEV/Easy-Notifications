import 'dart:async';
import 'dart:js' as js;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/services.dart';

/// The web implementation of [EasyNotifications].
class EasyNotificationsWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'easy_notifications',
      const StandardMethodCodec(),
      registrar,
    );
    final pluginInstance = EasyNotificationsWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'checkPermission':
        return _checkNotificationPermission();
      case 'requestPermission':
        return _requestNotificationPermission();
      case 'showNotification':
        return _showNotification(
            Map<String, dynamic>.from(call.arguments as Map));
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'easy_notifications for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  Future<bool> _checkNotificationPermission() async {
    if (!js.context.hasProperty('Notification')) {
      return false;
    }
    final permission = js.context['Notification']['permission'];
    return permission == 'granted';
  }

  Future<bool> _requestNotificationPermission() async {
    if (!js.context.hasProperty('Notification')) {
      return false;
    }
    final result =
        await js.context['Notification'].callMethod('requestPermission');
    return result == 'granted';
  }

  Future<void> _showNotification(Map<String, dynamic> arguments) async {
    if (!await _checkNotificationPermission()) {
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Notification permission not granted',
      );
    }

    final title = arguments['title'] as String;
    final body = arguments['body'] as String;
    final icon = arguments['icon'] as String?;

    final options = js.JsObject.jsify({
      'body': body,
      if (icon != null) 'icon': icon,
    });

    js.context['Notification'].newInstance([title, options]);
  }
}
