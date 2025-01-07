import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';

class NotificationAction {
  final String id;
  final String title;
  final VoidCallback onPressed;

  NotificationAction({
    required this.id,
    required this.title,
    required this.onPressed,
  });
}

class EasyNotifications {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static final Map<String, VoidCallback> _actionHandlers = {};
  static const _platform = MethodChannel('easy_notifications');
  static const int NOTIFICATION_ID = 1;

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

  static Future<bool> askPermission() async {
    try {
      if (Platform.isAndroid) {
        final androidImpl = _notifications.resolvePlatformSpecificImplementation<
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

  static Future<void> hide() async {
    await _notifications.cancel(NOTIFICATION_ID);
  }

  static Future<void> openApp() async {
    try {
      await _platform.invokeMethod('openApp');
    } on PlatformException {}
  }

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

  static Future<void> showMessage({
    required String title,
    required String body,
    String? imagePath,
    List<NotificationAction>? actions,
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
      for (var action in actions) {
        _actionHandlers[action.id] = action.onPressed;
      }
    }

    final androidActions = actions?.map(
      (action) => AndroidNotificationAction(
        action.id,
        action.title,
        showsUserInterface: true,
        cancelNotification: false,
      ),
    ).toList() ?? [];

    final androidDetails = AndroidNotificationDetails(
      'easy_notifications_channel',
      'Easy Notifications',
      channelDescription: 'Channel for easy notifications',
      importance: Importance.high,
      priority: Priority.high,
      actions: androidActions,
      icon: 'ic_launcher',
      largeIcon: localImagePath != null ? FilePathAndroidBitmap(localImagePath) : null,
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
      attachments: localImagePath != null ? [DarwinNotificationAttachment(localImagePath)] : null,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _notifications.show(NOTIFICATION_ID, title, body, details);
  }

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

  static Future<void> scheduleMessage({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? imagePath,
    List<NotificationAction>? actions,
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
      for (var action in actions) {
        _actionHandlers[action.id] = action.onPressed;
      }
    }

    final androidActions = actions?.map(
      (action) => AndroidNotificationAction(
        action.id,
        action.title,
        showsUserInterface: true,
        cancelNotification: false,
      ),
    ).toList() ?? [];

    final androidDetails = AndroidNotificationDetails(
      'easy_notifications_channel',
      'Easy Notifications',
      channelDescription: 'Channel for easy notifications',
      importance: Importance.high,
      priority: Priority.high,
      actions: androidActions,
      icon: 'ic_launcher',
      largeIcon: localImagePath != null ? FilePathAndroidBitmap(localImagePath) : null,
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
      attachments: localImagePath != null ? [DarwinNotificationAttachment(localImagePath)] : null,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      NOTIFICATION_ID,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> updateMessage({
    required String title,
    required String body,
    String? imagePath,
    List<NotificationAction>? actions,
  }) async {
    if (!_initialized) {
      await init();
    }
    final hasPermission = await askPermission();
    if (!hasPermission) {
      return;
    }
    if (actions != null) {
      for (var action in actions) {
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
      icon: 'app_icon',
      largeIcon:
          imagePath != null ? FilePathAndroidBitmap(imagePath) : null,
      styleInformation: imagePath != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(imagePath),
              largeIcon: FilePathAndroidBitmap(imagePath),
              contentTitle: title,
              summaryText: body,
              hideExpandedLargeIcon: false,
            )
          : null,
      channelShowBadge: true,
      autoCancel: false,
      ongoing: true,
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
      attachments:
          imagePath != null ? [DarwinNotificationAttachment(imagePath)] : null,
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );
    await _notifications.show(NOTIFICATION_ID, title, body, details);
  }
}
