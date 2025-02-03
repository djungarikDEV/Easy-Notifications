/// A Flutter plugin for handling local notifications with enhanced security and privacy features.
/// This plugin provides a simple interface for sending and managing local notifications
/// while ensuring user privacy and data protection.
library easy_notifications;

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';

/// The main class for handling notifications in the Easy Notifications plugin.
/// Provides methods for initializing the plugin and managing notifications.
class EasyNotifications {
  /// Checks if notifications are enabled for the application.
  /// Returns true if notifications are enabled, false otherwise.
  static Future<bool> areNotificationsEnabled() async {
    if (!_initialized) {
      await init();
    }
    if (Platform.isAndroid) {
      final androidImpl = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await androidImpl?.areNotificationsEnabled() ?? false;
    }
    return true;
  }

  /// Initializes the Easy Notifications plugin.
  /// Must be called before using any other methods.
  /// Returns true if initialization was successful.
  static Future<void> init({String? defaultIcon = 'ic_launcher'}) async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        final actionId = details.actionId;
        if (actionId != null && _actionHandlers.containsKey(actionId)) {
          _actionHandlers[actionId]?.call();
        }
      },
    );

    _initialized = true;
  }

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static final Map<String, VoidCallback> _actionHandlers = {};
  static const _platform = MethodChannel('easy_notifications');
  static String? defaultIcon;

  /// Initialize Easy Notifications with optional default settings
  static Future<void> initialize({String? defaultNotificationIcon}) async {
    defaultIcon = defaultNotificationIcon;
  }

  /// Asks the user for permission to display notifications.
  /// Returns true if permission was granted, false otherwise.
  static Future<bool> askPermission() async {
    try {
      if (Platform.isAndroid) {
        final androidImpl =
            _notifications.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final result = await androidImpl?.requestNotificationsPermission();
        return result ?? false;
      } else if (Platform.isIOS) {
        final iosImpl = _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        final result = await iosImpl?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return result ?? false;
      }
      return true;
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      return false;
    }
  }

  /// Hides the notification with the specified ID.
  /// Returns true if the notification was hidden, false otherwise.
  static Future<void> hide({int? id}) async {
    if (!_initialized) await init();
    final notificationId = id ?? _generateId();
    _validateNotificationId(notificationId);
    await _notifications.cancel(notificationId);
  }

  /// Opens the application.
  static Future<void> openApp() async {
    try {
      await _platform.invokeMethod('openApp');
    } on PlatformException catch (e) {
      debugPrint(
          'EasyNotifications: Platform exception occurred: ${e.message}');
      rethrow;
    }
  }

  /// Copies an asset to a local file.
  /// Returns the path to the local file, or null if the copy operation failed.
  static Future<String?> _copyAssetToLocal(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final List<int> bytes = data.buffer.asUint8List();

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(assetPath);
      final String localPath = p.join(appDir.path, 'notification_images');

      final Directory imageDir = Directory(localPath);
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      final String filePath = p.join(localPath, fileName);
      final File localFile = File(filePath);
      await localFile.writeAsBytes(bytes);

      debugPrint('Image copied to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error copying asset: $e');
      return null;
    }
  }

  /// Shows a notification with the specified title and message
  /// [id] must be a 32-bit integer between -2,147,483,648 and 2,147,483,647
  static Future<void> showMessage({
    required String title,
    required String body,
    String? message,
    String? imagePath,
    List<NotificationAction>? actions,
    String? icon,
    int? id,
  }) async {
    if (!_initialized) {
      await init();
    }

    final hasPermission = await askPermission();
    if (!hasPermission) {
      return;
    }

    String? localImagePath;
    if (imagePath != null) {
      localImagePath = await _copyAssetToLocal(imagePath);
      debugPrint('Local image path: $localImagePath');
    }

    if (actions != null) {
      for (final action in actions) {
        _actionHandlers[action.id] = action.onPressed;
      }
    }

    final androidActions = actions
            ?.map(
              (action) => AndroidNotificationAction(
                action.id,
                action.title,
                showsUserInterface: true,
                cancelNotification: false,
              ),
            )
            .toList() ??
        [];

    final androidDetails = AndroidNotificationDetails(
      'easy_notifications_channel',
      'Easy Notifications',
      channelDescription: 'Channel for easy notifications',
      importance: Importance.high,
      priority: Priority.high,
      actions: androidActions,
      icon: icon ?? defaultIcon ?? 'ic_launcher',
      largeIcon:
          localImagePath != null ? FilePathAndroidBitmap(localImagePath) : null,
      styleInformation: localImagePath != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(localImagePath),
              hideExpandedLargeIcon: true,
              contentTitle: title,
              summaryText: body,
            )
          : null,
      channelShowBadge: true,
      autoCancel: true,
      ongoing: false,
      playSound: true,
      enableLights: true,
      color: Colors.blue,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: actions != null ? 'actionable' : null,
      attachments: localImagePath != null
          ? [DarwinNotificationAttachment(localImagePath)]
          : null,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    final notificationId = id ?? _generateId();
    _validateNotificationId(notificationId);
    final content = message ?? body;
    await _notifications.show(notificationId, title, content, details);
  }

  /// Updates a notification with the specified title, body, and image.
  /// Returns true if the notification was updated, false otherwise.
  static Future<void> updateMessage({
    required String title,
    required String body,
    int? id,
  }) async {
    final notificationId = id ?? _generateId();
    _validateNotificationId(notificationId);
    await _notifications.cancel(notificationId);
    await showMessage(title: title, body: body, id: notificationId);
  }

  /// Schedules a notification to be shown at the specified date and time.
  /// Returns true if the notification was scheduled, false otherwise.
  static Future<void> scheduleMessage({
    required String title,
    required String body,
    required DateTime scheduledDate,
    int? id,
  }) async {
    final notificationId = id ?? _generateId();
    _validateNotificationId(notificationId);
    await _notifications.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static int _generateId() {
    return DateTime.now().millisecondsSinceEpoch % (1 << 31);
  }

  static void _validateNotificationId(int id) {
    if (id < -2147483648 || id > 2147483647) {
      throw ArgumentError('Notification ID must be 32-bit integer (between -2^31 and 2^31-1). Received: $id');
    }
  }
}

/// A class representing a notification action.
class NotificationAction {
  /// The unique identifier for the action.
  final String id;

  /// The title of the action.
  final String title;

  /// The callback function to be executed when the action is pressed.
  final VoidCallback onPressed;

  /// Creates a new notification action.
  NotificationAction({
    required this.id,
    required this.title,
    required this.onPressed,
  });
}
