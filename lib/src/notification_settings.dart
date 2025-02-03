import 'package:json_annotation/json_annotation.dart';

part 'notification_settings.g.dart';

@JsonSerializable()
class NotificationSettings {
  /// Whether to show notifications when app is in foreground
  final bool showInForeground;

  /// Whether to play sound when notification arrives
  final bool playSound;

  /// Whether to show notification badge on app icon
  final bool showBadge;

  /// Whether to enable notification lights (Android only)
  final bool enableLights;

  /// Whether to enable notification vibration
  final bool enableVibration;

  /// Custom vibration pattern (Android only)
  final List<int>? vibrationPattern;

  /// Priority of the notification (Android only)
  final NotificationPriority priority;

  /// Importance of the notification channel (Android only)
  final NotificationImportance importance;

  /// Custom notification sound
  final String? soundName;

  /// Color of notification LED (Android only)
  final int? ledColor;

  /// Duration of LED on state in milliseconds (Android only)
  final int? ledOnMs;

  /// Duration of LED off state in milliseconds (Android only)
  final int? ledOffMs;

  /// Group key for notification grouping (Android only)
  final String? groupKey;

  /// Whether to group similar notifications (Android only)
  final bool groupSimilar;

  /// Whether to use big text style for long messages
  final bool useBigTextStyle;

  /// Whether to auto-cancel notification when tapped
  final bool autoCancel;

  /// Whether to show timestamp
  final bool showTimestamp;

  /// Custom notification icon (Android only)
  final String? icon;

  /// Category of notification (iOS only)
  final String? category;

  /// Thread identifier for notification grouping (iOS only)
  final String? threadIdentifier;

  const NotificationSettings({
    this.showInForeground = true,
    this.playSound = true,
    this.showBadge = true,
    this.enableLights = true,
    this.enableVibration = true,
    this.vibrationPattern,
    this.priority = NotificationPriority.defaultPriority,
    this.importance = NotificationImportance.defaultImportance,
    this.soundName,
    this.ledColor,
    this.ledOnMs,
    this.ledOffMs,
    this.groupKey,
    this.groupSimilar = false,
    this.useBigTextStyle = true,
    this.autoCancel = true,
    this.showTimestamp = true,
    this.icon,
    this.category,
    this.threadIdentifier,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);

  NotificationSettings copyWith({
    bool? showInForeground,
    bool? playSound,
    bool? showBadge,
    bool? enableLights,
    bool? enableVibration,
    List<int>? vibrationPattern,
    NotificationPriority? priority,
    NotificationImportance? importance,
    String? soundName,
    int? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    String? groupKey,
    bool? groupSimilar,
    bool? useBigTextStyle,
    bool? autoCancel,
    bool? showTimestamp,
    String? icon,
    String? category,
    String? threadIdentifier,
  }) {
    return NotificationSettings(
      showInForeground: showInForeground ?? this.showInForeground,
      playSound: playSound ?? this.playSound,
      showBadge: showBadge ?? this.showBadge,
      enableLights: enableLights ?? this.enableLights,
      enableVibration: enableVibration ?? this.enableVibration,
      vibrationPattern: vibrationPattern ?? this.vibrationPattern,
      priority: priority ?? this.priority,
      importance: importance ?? this.importance,
      soundName: soundName ?? this.soundName,
      ledColor: ledColor ?? this.ledColor,
      ledOnMs: ledOnMs ?? this.ledOnMs,
      ledOffMs: ledOffMs ?? this.ledOffMs,
      groupKey: groupKey ?? this.groupKey,
      groupSimilar: groupSimilar ?? this.groupSimilar,
      useBigTextStyle: useBigTextStyle ?? this.useBigTextStyle,
      autoCancel: autoCancel ?? this.autoCancel,
      showTimestamp: showTimestamp ?? this.showTimestamp,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      threadIdentifier: threadIdentifier ?? this.threadIdentifier,
    );
  }
}

enum NotificationPriority {
  min,
  low,
  defaultPriority,
  high,
  max,
}

enum NotificationImportance {
  none,
  min,
  low,
  defaultImportance,
  high,
  max,
}
