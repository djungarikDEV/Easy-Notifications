# Changelog

## 1.2.5

* Fixed web notifications registration
* Added proper error handling for web platform

## 1.2.4

* Added back NotificationLevel class for backwards compatibility

## 1.2.3

* Small bug fixed

## 1.2.2

* Removed unsupported platforms from documentation (Windows, macOS, Linux)

## 1.2.1

* Fixed code formatting issues
* Updated repository and issue tracker URLs
* Improved platform support documentation
* Removed unsupported platforms from documentation

## 1.2.0

* Added support for Web
* Added new NotificationSettings class for advanced notification configuration
* Added new NotificationStyle class for customizing notification appearance
* Updated all dependencies to latest versions
* Added support for JSON serialization
* Improved error handling and logging
* Added support for custom notification sounds
* Added support for notification grouping
* Added support for big text style
* Added support for LED customization on Android
* Added support for custom vibration patterns
* Added support for notification categories on iOS
* Added support for thread identifiers on iOS

## 1.1.9

* Completely redesigned plugin architecture for simplicity and efficiency
* Enhanced local notifications system
* New initialization flow with improved error handling
* Simplified API for notifications

## 1.1.8
* Fixed notification issues on Android 13+
* Improved permission handling for notifications
* Added proper notification channel initialization
* Enhanced security with exported=false for broadcast receivers
* Updated dependencies to latest stable versions
* Fixed ic_launcher icon path issues
* Added support for critical notifications on iOS
* Improved error handling and logging
* Updated package dependencies

## 1.1.7

* Small bug fixed

## 1.1.6

* Added support for default notification icon configuration
* Added plugin logoc
* Improved documentation

## 1.0.5

* Added iOS podspec and native implementation
* Fixed iOS platform support and configuration
* Updated dependencies to latest versions
* Improved error handling and stability

## 1.0.4

* Updated flutter_local_notifications to ^18.0.1
* Updated timezone to ^0.10.0
* Updated path_provider to ^2.1.5
* Updated path to ^1.9.1
* Updated plugin_platform_interface to ^2.1.8
* Clarified that init() and askPermission() are optional in documentation

## 1.0.3a

* Updated flutter_local_notifications to ^18.0.1
* Updated timezone to ^0.10.0
* Updated path_provider to ^2.1.5
* Updated path to ^1.9.1
* Updated plugin_platform_interface to ^2.1.8
* Clarified that init() and askPermission() are optional in documentation

## 1.0.3

* Fixed androidAllowWhileIdle deprecation warning
* Updated to use androidScheduleMode instead
* Fixed notification scheduling on newer Android versions
* Updated dependencies to latest versions

## 1.0.2

* Added default notification icon configuration via AndroidManifest.xml
* Fixed notification initialization and permission handling
* Improved error handling for notification scheduling
* Removed invalid dispose call
* Updated documentation with Android setup instructions

## 1.0.1

* Fixed Android platform implementation
* Added proper plugin configuration

## 1.0.0

* Initial release
* Support for Android and iOS platforms
* Basic notification functionality
* Permission handling
* High-priority notifications

### Added
- Secure notification handling system
- Cross-platform support (Android & iOS)
- Rich media notifications with local image processing
- Precise scheduling with timezone support
- Privacy-focused permission handling
- Comprehensive documentation
- Security best practices implementation
- Example application
- Unit and integration tests

### Security
- Implemented secure file handling
- Added permission management
- Integrated privacy-preserving logging
- Added data cleanup routines

## 0.0.1

- Initial development version (not released)
