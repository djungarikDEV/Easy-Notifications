# Easy Notifications Example

This example demonstrates various features of the Easy Notifications package.

## Features Demonstrated

1. **Simple Notification**
   - Basic notification with title and body

2. **Notification with Image**
   - Display notifications with custom images
   - Support for local assets and network images
   - Automatic image handling and caching

3. **Notification with Actions**
   - Notification with custom action buttons
   - Handling action button taps

4. **Scheduled Notification**
   - Schedule notifications for future delivery
   - Date and time picker for scheduling
   - Alarm clock mode for precise timing

5. **Updatable Notification**
   - Update existing notification content
   - Progress indicator example
   - Simulated download progress

## Running the Example

1. Clone the repository
2. Navigate to the example directory
3. Run `flutter pub get`
4. Run `flutter run`

## Code Structure

The example is organized into different sections, each demonstrating a specific feature:

- `main.dart`: Main application entry point
- `HomePage`: Contains all the example widgets
  - Simple notification demo
  - Image notification demo
  - Actions notification demo
  - Scheduled notification demo
  - Updatable notification demo

## Assets

The example includes sample images in the `assets/images` directory:
- `notification_image.jpg`: Sample image for notification with image demo

Make sure to include these assets in your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

## Usage Notes

- Make sure to grant notification permissions when prompted
- For scheduled notifications, the example uses the device's local timezone
- The progress notification example simulates a download process
- Image notifications work best with images that are not too large
