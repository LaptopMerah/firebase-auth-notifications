import 'package:auth_firebase/pages/login_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:auth_firebase/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Logged in as ${snapshot.data?.email}'),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => logout(context),
                      child: const Text('Logout'),
                    ),
                  ],
                );
              } else {
                return const LoginPage();
              }
            },
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 1,
                title: 'Default Notification',
                body: 'This is the body of the notification',
                summary: 'Small summary',
              );
            },
            child: const Text('Default Notification'),
          ),
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 2,
                title: 'Notification with Summary',
                body: 'This is the body of the notification',
                summary: 'Small summary',
                notificationLayout: NotificationLayout.Inbox,
              );
            },
            child: const Text('Notification with Summary'),
          ),
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 3,
                title: 'Progress Bar Notification',
                body: 'This is the body of the notification',
                summary: 'Small summary',
                notificationLayout: NotificationLayout.ProgressBar,
              );
            },
            child: const Text('Progress Bar Notification'),
          ),
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 4,
                title: 'Message Notification',
                body: 'This is the body of the notification',
                summary: 'Small summary',
                notificationLayout: NotificationLayout.Messaging,
              );
            },
            child: const Text('Message Notification'),
          ),
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 5,
                title: 'Big Image Notification',
                body: 'This is the body of the notification',
                summary: 'Small summary',
                notificationLayout: NotificationLayout.BigPicture,
                bigPicture: 'https://picsum.photos/300/200',
              );
            },
            child: const Text('Big Image Notification'),
          ),
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 5,
                title: 'Action Button Notification',
                body: 'This is the body of the notification',
                payload: {'navigate': 'true'},
                actionButtons: [
                  NotificationActionButton(
                    key: 'action_button',
                    label: 'Click me',
                    actionType: ActionType.Default,
                  ),
                ],
              );
            },
            child: const Text('Action Button Notification'),
          ),
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 5,
                title: 'Scheduled Notification',
                body: 'This is the body of the notification',
                scheduled: true,
                interval: const Duration(seconds: 5),
              );
            },
            child: const Text('Scheduled Notification'),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'notes');
            },
            child: const Text('Go to Notes Page'),
          ),
        ],
      ),
    );
  }
}
