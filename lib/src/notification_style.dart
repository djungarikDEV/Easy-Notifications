import 'package:json_annotation/json_annotation.dart';
import 'edge_insets_converter.dart';

part 'notification_style.g.dart';

@JsonSerializable()
class NotificationStyle {
  /// Background color of the notification
  final String? backgroundColor;

  /// Text color for the title
  final String? titleColor;

  /// Text color for the body
  final String? bodyColor;

  /// Font size for the title
  final double? titleFontSize;

  /// Font size for the body
  final double? bodyFontSize;

  /// Font weight for the title
  final FontWeight titleFontWeight;

  /// Font weight for the body
  final FontWeight bodyFontWeight;

  /// Padding around the notification content
  @EdgeInsetsConverter()
  final EdgeInsets padding;

  /// Border radius of the notification
  final double borderRadius;

  /// Border color of the notification
  final String? borderColor;

  /// Border width of the notification
  final double borderWidth;

  /// Shadow color of the notification
  final String? shadowColor;

  /// Shadow blur radius
  final double shadowBlurRadius;

  /// Shadow spread radius
  final double shadowSpreadRadius;

  /// Shadow offset X
  final double shadowOffsetX;

  /// Shadow offset Y
  final double shadowOffsetY;

  /// Progress bar color (if applicable)
  final String? progressBarColor;

  /// Progress bar background color (if applicable)
  final String? progressBarBackgroundColor;

  /// Action button text color
  final String? actionButtonTextColor;

  /// Action button background color
  final String? actionButtonBackgroundColor;

  const NotificationStyle({
    this.backgroundColor,
    this.titleColor,
    this.bodyColor,
    this.titleFontSize,
    this.bodyFontSize,
    this.titleFontWeight = FontWeight.bold,
    this.bodyFontWeight = FontWeight.normal,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 8,
    this.borderColor,
    this.borderWidth = 0,
    this.shadowColor,
    this.shadowBlurRadius = 0,
    this.shadowSpreadRadius = 0,
    this.shadowOffsetX = 0,
    this.shadowOffsetY = 0,
    this.progressBarColor,
    this.progressBarBackgroundColor,
    this.actionButtonTextColor,
    this.actionButtonBackgroundColor,
  });

  factory NotificationStyle.fromJson(Map<String, dynamic> json) =>
      _$NotificationStyleFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationStyleToJson(this);

  NotificationStyle copyWith({
    String? backgroundColor,
    String? titleColor,
    String? bodyColor,
    double? titleFontSize,
    double? bodyFontSize,
    FontWeight? titleFontWeight,
    FontWeight? bodyFontWeight,
    EdgeInsets? padding,
    double? borderRadius,
    String? borderColor,
    double? borderWidth,
    String? shadowColor,
    double? shadowBlurRadius,
    double? shadowSpreadRadius,
    double? shadowOffsetX,
    double? shadowOffsetY,
    String? progressBarColor,
    String? progressBarBackgroundColor,
    String? actionButtonTextColor,
    String? actionButtonBackgroundColor,
  }) {
    return NotificationStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleColor: titleColor ?? this.titleColor,
      bodyColor: bodyColor ?? this.bodyColor,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      bodyFontSize: bodyFontSize ?? this.bodyFontSize,
      titleFontWeight: titleFontWeight ?? this.titleFontWeight,
      bodyFontWeight: bodyFontWeight ?? this.bodyFontWeight,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius ?? this.shadowSpreadRadius,
      shadowOffsetX: shadowOffsetX ?? this.shadowOffsetX,
      shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,
      progressBarColor: progressBarColor ?? this.progressBarColor,
      progressBarBackgroundColor: progressBarBackgroundColor ?? this.progressBarBackgroundColor,
      actionButtonTextColor: actionButtonTextColor ?? this.actionButtonTextColor,
      actionButtonBackgroundColor: actionButtonBackgroundColor ?? this.actionButtonBackgroundColor,
    );
  }
}

enum FontWeight {
  normal,
  bold,
  w100,
  w200,
  w300,
  w400,
  w500,
  w600,
  w700,
  w800,
  w900,
}

class EdgeInsets {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const EdgeInsets.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const EdgeInsets.only({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });

  const EdgeInsets.symmetric({
    double vertical = 0,
    double horizontal = 0,
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;
}
