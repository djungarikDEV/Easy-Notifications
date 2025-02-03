
part of 'notification_style.dart';

NotificationStyle _$NotificationStyleFromJson(Map<String, dynamic> json) =>
    NotificationStyle(
      backgroundColor: json['backgroundColor'] as String?,
      titleColor: json['titleColor'] as String?,
      bodyColor: json['bodyColor'] as String?,
      titleFontSize: (json['titleFontSize'] as num?)?.toDouble(),
      bodyFontSize: (json['bodyFontSize'] as num?)?.toDouble(),
      titleFontWeight:
          $enumDecodeNullable(_$FontWeightEnumMap, json['titleFontWeight']) ??
              FontWeight.bold,
      bodyFontWeight:
          $enumDecodeNullable(_$FontWeightEnumMap, json['bodyFontWeight']) ??
              FontWeight.normal,
      padding: json['padding'] == null
          ? const EdgeInsets.all(16)
          : const EdgeInsetsConverter()
              .fromJson(json['padding'] as Map<String, dynamic>),
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 8,
      borderColor: json['borderColor'] as String?,
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 0,
      shadowColor: json['shadowColor'] as String?,
      shadowBlurRadius: (json['shadowBlurRadius'] as num?)?.toDouble() ?? 0,
      shadowSpreadRadius: (json['shadowSpreadRadius'] as num?)?.toDouble() ?? 0,
      shadowOffsetX: (json['shadowOffsetX'] as num?)?.toDouble() ?? 0,
      shadowOffsetY: (json['shadowOffsetY'] as num?)?.toDouble() ?? 0,
      progressBarColor: json['progressBarColor'] as String?,
      progressBarBackgroundColor: json['progressBarBackgroundColor'] as String?,
      actionButtonTextColor: json['actionButtonTextColor'] as String?,
      actionButtonBackgroundColor:
          json['actionButtonBackgroundColor'] as String?,
    );

Map<String, dynamic> _$NotificationStyleToJson(NotificationStyle instance) =>
    <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'titleColor': instance.titleColor,
      'bodyColor': instance.bodyColor,
      'titleFontSize': instance.titleFontSize,
      'bodyFontSize': instance.bodyFontSize,
      'titleFontWeight': _$FontWeightEnumMap[instance.titleFontWeight]!,
      'bodyFontWeight': _$FontWeightEnumMap[instance.bodyFontWeight]!,
      'padding': const EdgeInsetsConverter().toJson(instance.padding),
      'borderRadius': instance.borderRadius,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
      'shadowColor': instance.shadowColor,
      'shadowBlurRadius': instance.shadowBlurRadius,
      'shadowSpreadRadius': instance.shadowSpreadRadius,
      'shadowOffsetX': instance.shadowOffsetX,
      'shadowOffsetY': instance.shadowOffsetY,
      'progressBarColor': instance.progressBarColor,
      'progressBarBackgroundColor': instance.progressBarBackgroundColor,
      'actionButtonTextColor': instance.actionButtonTextColor,
      'actionButtonBackgroundColor': instance.actionButtonBackgroundColor,
    };

const _$FontWeightEnumMap = {
  FontWeight.normal: 'normal',
  FontWeight.bold: 'bold',
  FontWeight.w100: 'w100',
  FontWeight.w200: 'w200',
  FontWeight.w300: 'w300',
  FontWeight.w400: 'w400',
  FontWeight.w500: 'w500',
  FontWeight.w600: 'w600',
  FontWeight.w700: 'w700',
  FontWeight.w800: 'w800',
  FontWeight.w900: 'w900',
};
