
part of 'notification_settings.dart';

NotificationSettings _$NotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    NotificationSettings(
      showInForeground: json['showInForeground'] as bool? ?? true,
      playSound: json['playSound'] as bool? ?? true,
      showBadge: json['showBadge'] as bool? ?? true,
      enableLights: json['enableLights'] as bool? ?? true,
      enableVibration: json['enableVibration'] as bool? ?? true,
      vibrationPattern: (json['vibrationPattern'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      priority: $enumDecodeNullable(
              _$NotificationPriorityEnumMap, json['priority']) ??
          NotificationPriority.defaultPriority,
      importance: $enumDecodeNullable(
              _$NotificationImportanceEnumMap, json['importance']) ??
          NotificationImportance.defaultImportance,
      soundName: json['soundName'] as String?,
      ledColor: (json['ledColor'] as num?)?.toInt(),
      ledOnMs: (json['ledOnMs'] as num?)?.toInt(),
      ledOffMs: (json['ledOffMs'] as num?)?.toInt(),
      groupKey: json['groupKey'] as String?,
      groupSimilar: json['groupSimilar'] as bool? ?? false,
      useBigTextStyle: json['useBigTextStyle'] as bool? ?? true,
      autoCancel: json['autoCancel'] as bool? ?? true,
      showTimestamp: json['showTimestamp'] as bool? ?? true,
      icon: json['icon'] as String?,
      category: json['category'] as String?,
      threadIdentifier: json['threadIdentifier'] as String?,
    );

Map<String, dynamic> _$NotificationSettingsToJson(
        NotificationSettings instance) =>
    <String, dynamic>{
      'showInForeground': instance.showInForeground,
      'playSound': instance.playSound,
      'showBadge': instance.showBadge,
      'enableLights': instance.enableLights,
      'enableVibration': instance.enableVibration,
      'vibrationPattern': instance.vibrationPattern,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
      'importance': _$NotificationImportanceEnumMap[instance.importance]!,
      'soundName': instance.soundName,
      'ledColor': instance.ledColor,
      'ledOnMs': instance.ledOnMs,
      'ledOffMs': instance.ledOffMs,
      'groupKey': instance.groupKey,
      'groupSimilar': instance.groupSimilar,
      'useBigTextStyle': instance.useBigTextStyle,
      'autoCancel': instance.autoCancel,
      'showTimestamp': instance.showTimestamp,
      'icon': instance.icon,
      'category': instance.category,
      'threadIdentifier': instance.threadIdentifier,
    };

const _$NotificationPriorityEnumMap = {
  NotificationPriority.min: 'min',
  NotificationPriority.low: 'low',
  NotificationPriority.defaultPriority: 'defaultPriority',
  NotificationPriority.high: 'high',
  NotificationPriority.max: 'max',
};

const _$NotificationImportanceEnumMap = {
  NotificationImportance.none: 'none',
  NotificationImportance.min: 'min',
  NotificationImportance.low: 'low',
  NotificationImportance.defaultImportance: 'defaultImportance',
  NotificationImportance.high: 'high',
  NotificationImportance.max: 'max',
};
