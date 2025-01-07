import 'package:flutter/material.dart';
import 'package:easy_notifications/easy_notifications.dart';

// No initialization needed! Just start the app
void main() {
  runApp(const NotificationsExample());
}

class NotificationsExample extends StatelessWidget {
  const NotificationsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Notifications Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _scheduledDate = DateTime.now().add(const Duration(minutes: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Notifications Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Simple notification
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Simple Notification',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      // Just one line of code!
                      await EasyNotifications.showMessage(
                        title: 'Hello! 👋',
                        body: 'This is a simple notification',
                      );
                    },
                    child: const Text('Show Simple Notification'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notification with image
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notification with Image',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await EasyNotifications.showMessage(
                        title: 'Hello from Hamster! 🐹',
                        body: 'Time to feed your pet!',
                        imagePath: 'assets/images/hamster_on_hands.jpg',
                        actions: [
                          NotificationAction(
                            id: 'feed',
                            title: 'Feed Now',
                            onPressed: () {
                              EasyNotifications.openApp();
                            },
                          ),
                          NotificationAction(
                            id: 'later',
                            title: 'Later',
                            onPressed: () {
                              EasyNotifications.hide();
                            },
                          ),
                        ],
                      );
                    },
                    child: const Text('Show Notification with Image'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notification with actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notification with Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await EasyNotifications.showMessage(
                        title: 'Action Required 🔔',
                        body: 'This notification has actions!',
                        actions: [
                          NotificationAction(
                            id: 'open',
                            title: 'Open App',
                            onPressed: () {
                              EasyNotifications.openApp();
                            },
                          ),
                          NotificationAction(
                            id: 'dismiss',
                            title: 'Dismiss',
                            onPressed: () {
                              EasyNotifications.hide();
                            },
                          ),
                        ],
                      );
                    },
                    child: const Text('Show Notification with Actions'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Scheduled notification
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scheduled Notification',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text('Schedule Time'),
                    subtitle: Text(
                      _scheduledDate.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _scheduledDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_scheduledDate),
                          );
                          if (time != null) {
                            setState(() {
                              _scheduledDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await EasyNotifications.scheduleMessage(
                        title: 'Time to Feed! ⏰',
                        body: "Don't forget to feed your hamster!",
                        scheduledDate: _scheduledDate,
                        actions: [
                          NotificationAction(
                            id: 'feed',
                            title: 'Feed Now',
                            onPressed: () {
                              EasyNotifications.openApp();
                            },
                          ),
                        ],
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Reminder scheduled for $_scheduledDate',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Schedule Notification'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Updatable notification
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Updatable Notification',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await EasyNotifications.showMessage(
                        title: 'Hamster is Playing! 🐹',
                        body: 'Activity: 0%',
                      );

                      for (int i = 1; i <= 10; i++) {
                        await Future.delayed(const Duration(seconds: 1));
                        await EasyNotifications.updateMessage(
                          title: 'Hamster is Running! 🏃',
                          body: 'Activity: ${i * 10}%',
                          actions: [
                            NotificationAction(
                              id: 'stop',
                              title: 'Stop',
                              onPressed: () {
                                EasyNotifications.hide();
                              },
                            ),
                          ],
                        );
                      }

                      await EasyNotifications.updateMessage(
                        title: 'Hamster is Tired! 😴',
                        body: 'Time to rest',
                        actions: [
                          NotificationAction(
                            id: 'check',
                            title: 'Check',
                            onPressed: () {
                              EasyNotifications.openApp();
                            },
                          ),
                        ],
                      );
                    },
                    child: const Text('Show Progress Notification'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
