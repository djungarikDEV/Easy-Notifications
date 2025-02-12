# Easy Notifications

![Easy Notifications Logo](https://github.com/djungarikDEV/Easy-Notifications/raw/main/example/assets/easy_notifications_logo.jpg)

[![Pub Version](https://img.shields.io/pub/v/easy_notifications.svg)](https://pub.dev/packages/easy_notifications)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform Support](https://img.shields.io/badge/platform-android%20|%20ios%20|%20web-blue.svg)](https://pub.dev/packages/easy_notifications)
[![Flutter Support](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-blue.svg)](https://flutter.dev)
[![Pub Points](https://img.shields.io/pub/points/easy_notifications)](https://pub.dev/packages/easy_notifications/score)
[![Support me](https://img.shields.io/badge/Support%20me-DonationAlerts)](https://www.donationalerts.com/r/djungarikdev)

A secure and privacy-focused Flutter plugin for handling local notifications with enhanced features and SOC 2 compliance considerations. Supports Android, iOS, Web platforms.

## Features

- 🔒 Secure handling of notification data
- 🎯 Precise scheduling with timezone support
- 🖼️ Rich media notifications (images, custom styles)
- 📱 Cross-platform support (Android, iOS, Web)
- 🔐 Granular permission controls
- 📋 Action buttons support
- ⏰ Exact timing with background wake-up support
- 🛡️ Privacy-first approach
- 🎨 Highly customizable appearance (NotificationStyle)
- 🔧 Advanced configuration (NotificationSettings)
- 🔄 JSON serialization support

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  easy_notifications: ^1.2.5
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

#### Web

To enable web notifications, you need to add the following script to your `index.html` file:

```html
<script>
  if ('Notification' in window) {
    Notification.requestPermission().then(permission => {
      if (permission === 'granted') {
        console.log('Notification permission granted.');
      }
    });
  }
</script>
```

### Basic Usage

```dart
// Initialize the plugin
await EasyNotifications.init();

// Show a simple notification
await EasyNotifications.show(
  title: 'Hello!',
  body: 'This is a notification',
);

// Show notification with image and custom style
await EasyNotifications.show(
  title: 'Styled Notification',
  body: 'With custom appearance',
  style: NotificationStyle(
    backgroundColor: '#FFFFFF',
    titleColor: '#000000',
    padding: const EdgeInsets.all(16),
  ),
);

// Schedule a notification
await EasyNotifications.schedule(
  title: 'Reminder',
  body: 'Time for your meeting!',
  scheduledDate: DateTime.now().add(Duration(hours: 1)),
);
```

## Usage

```dart
EasyNotifications.showMessage(
  title: 'New Message',
  body: 'You have a new notification',
  id: 1001, // Optional custom ID
);
```

## Notifications Preview

![Preview](https://github.com/djungarikDEV/Easy-Notifications/raw/main/example/assets/preview.jpg)

## Recent Updates

### 1.2.5

* Fixed web notifications registration
* Added proper error handling for web platform

### 1.2.4

* Added back NotificationLevel class for backwards compatibility

### 1.2.3

* Fixed platform support documentation
* Removed unsupported platforms from pubspec.yaml

## Security & Privacy

### Data Handling
- 🔐 All sensitive data encrypted at rest
- 🗑️ Automatic cleanup of temporary files
- 📁 Secure local storage practices

### Compliance
- SOC 2 Type II compliant architecture
- GDPR-ready data processing
- CCPA privacy controls

## Contributing

We welcome contributions! Please see our [contributing guide](CONTRIBUTING.md).

## License

MIT License - see [LICENSE](LICENSE) for details.
