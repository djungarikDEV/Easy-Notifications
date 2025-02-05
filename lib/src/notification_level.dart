import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationLevel {
  final bool badge;
  final bool sound;
  final bool lights;
  final bool alert;
  final Importance importance;
  final Priority priority;
  final NotificationVisibility visibility;

  const NotificationLevel({
    this.badge = true,
    this.sound = true,
    this.lights = true,
    this.alert = true,
    this.importance = Importance.max,
    this.priority = Priority.max,
    this.visibility = NotificationVisibility.public,
  });

  const NotificationLevel.urgent()
      : this(
          badge: true,
          sound: true,
          lights: true,
          alert: true,
          importance: Importance.max,
          priority: Priority.max,
          visibility: NotificationVisibility.public,
        );

  const NotificationLevel.normal()
      : this(
          badge: true,
          sound: true,
          lights: false,
          alert: true,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          visibility: NotificationVisibility.private,
        );

  const NotificationLevel.low()
      : this(
          badge: false,
          sound: false,
          lights: false,
          alert: false,
          importance: Importance.low,
          priority: Priority.low,
          visibility: NotificationVisibility.secret,
        );
}
