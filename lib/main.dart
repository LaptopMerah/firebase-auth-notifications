import 'package:auth_firebase/pages/home_page.dart';
import 'package:auth_firebase/pages/login_page.dart';
import 'package:auth_firebase/pages/notes_page.dart';
import 'package:auth_firebase/pages/register_page.dart';
import 'package:auth_firebase/pages/second_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:auth_firebase/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initializeNotification();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login',
      navigatorKey: navigatorKey,
      routes: {
        'home': (context) => const HomePage(),
        'second': (context) => const SecondPage(),
        'login': (context) => const LoginPage(),
        'register': (context) => const RegisterPage(),
        'notes': (context) => const NotesPage(),
      },
    );
  }
}
