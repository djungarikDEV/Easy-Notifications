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

  /// The notification ID used for all notifications
  static const notificationId = 1;

  /// Initializes the Easy Notifications plugin.
  /// Must be called before using any other methods.
  /// Returns true if initialization was successful.
  static Future<void> init() async {
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
  static Future<void> hide() async {
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

  /// Shows a notification with the specified title, body, and image.
  /// Returns true if the notification was shown, false otherwise.
  static Future<void> showMessage({
    required String title,
    required String body,
    String? imagePath,
    List<NotificationAction>? actions,
    String? icon,
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

    await _notifications.show(notificationId, title, body, details);
  }

  /// Schedules a notification to be shown at the specified date and time.
  /// Returns true if the notification was scheduled, false otherwise.
  static Future<void> scheduleMessage({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? imagePath,
    List<NotificationAction>? actions,
    String? icon,
    NotificationLevel level = const NotificationLevel.urgent(),
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
      importance: level.importance,
      priority: level.priority,
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
      channelShowBadge: level.badge,
      autoCancel: true,
      ongoing: false,
      playSound: level.sound,
      enableLights: level.lights,
      color: Colors.blue,
      visibility: NotificationVisibility.public,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: level.alert,
      presentBadge: level.badge,
      presentSound: level.sound,
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

    await _notifications.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Updates a notification with the specified title, body, and image.
  /// Returns true if the notification was updated, false otherwise.
  static Future<void> updateMessage({
    required String title,
    required String body,
    String? imagePath,
    List<NotificationAction>? actions,
    String? icon,
  }) async {
    if (!_initialized) {
      await init();
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
      ongoing: true, // Required for updatable notifications
      playSound: false, // Don't play sound on updates
      enableLights: true,
      onlyAlertOnce: true, // Show alert only on first notification
      color: Colors.blue,
      visibility: NotificationVisibility.public,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false, // Don't play sound on updates
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

    await _notifications.show(notificationId, title, body, details);
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

class NotificationLevel {
  const NotificationLevel.urgent()
      : badge = true,
        sound = true,
        lights = true,
        alert = true,
        importance = Importance.max,
        priority = Priority.max;

  const NotificationLevel.normal()
      : badge = true,
        sound = true,
        lights = false,
        alert = true,
        importance = Importance.defaultImportance,
        priority = Priority.defaultPriority;

  const NotificationLevel.subtle()
      : badge = false,
        sound = false,
        lights = false,
        alert = false,
        importance = Importance.low,
        priority = Priority.low;

  const NotificationLevel.custom({
    required this.badge,
    required this.sound,
    required this.lights,
    required this.alert,
    required this.importance,
    required this.priority,
  });

  final bool badge;
  final bool sound;
  final bool lights;
  final bool alert;
  final Importance importance;
  final Priority priority;
}
