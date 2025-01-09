# Easy Notifications

[![pub package](https://img.shields.io/pub/v/easy_notifications.svg)](https://pub.dev/packages/easy_notifications)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A secure and privacy-focused Flutter plugin for handling local notifications with enhanced features and SOC 2 compliance considerations.

## Features

- 🔒 Secure handling of notification data
- 🎯 Precise scheduling with timezone support
- 🖼️ Rich media notifications (images, custom styles)
- 📱 Cross-platform support (Android & iOS)
- 🔐 Permission handling best practices
- 📋 Action buttons support
- ⏰ Exact timing with background wake-up support
- 🛡️ Privacy-first approach

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  easy_notifications: ^1.0.4
```

### Platform Setup

#### Android

Add the following permissions to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

#### iOS

Add the following keys to your `Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

### Basic Usage

```dart
// Initialize the plugin(Not required)
await EasyNotifications.init();

// Request permissions(Not required)
final hasPermission = await EasyNotifications.askPermission();

// Show a simple notification
await EasyNotifications.showMessage(
  title: 'Hello!',
  body: 'This is a notification',
);

// Show a notification with an image
await EasyNotifications.showMessage(
  title: 'Hello!',
  body: 'This is a notification with an image',
  imagePath: 'assets/images/notification_image.jpg',
);

// Schedule a notification
await EasyNotifications.scheduleMessage(
  title: 'Reminder',
  body: 'Time for your meeting!',
  scheduledDate: DateTime.now().add(Duration(hours: 1)),
);

## Recent Updates

### Version 1.0.4
* Updated all dependencies to latest versions
* Improved documentation clarity
* Enhanced compatibility with latest Flutter version

### Version 1.0.3
* Fixed Android implementation and configuration
* Added proper permissions handling
* Improved platform compatibility
* Enhanced error handling

### Android Setup
Make sure to add the following permissions to your Android Manifest:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
```

## Security & Privacy Considerations

### Data Storage
- All temporary files are stored in the app's secure directory
- Images are processed locally without external uploads
- Notification data is not persisted beyond its lifetime

### Permissions
- Minimal permissions requested
- Clear user consent flows
- Granular permission controls

### Best Practices
- No sensitive data in notifications
- Secure local storage handling
- Privacy-preserving logging

## Contributing

We welcome contributions! Please see our [contributing guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Compliance

This plugin is designed with SOC 2 compliance in mind:
- Security: Implements secure data handling practices
- Availability: Ensures reliable notification delivery
- Processing Integrity: Maintains accurate scheduling
- Confidentiality: Protects user data
- Privacy: Respects user consent and data rights
