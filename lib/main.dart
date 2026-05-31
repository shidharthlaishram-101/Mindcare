import 'package:flutter/material.dart';
import 'package:mindcare/start.dart';
import 'package:mindcare/home.dart'; // 👈 your home/dashboard screen
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Still loading Firebase session
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // User is logged in → go to home
          if (snapshot.hasData) {
            return HomePage(); // 👈 replace with your actual home widget
          }

          // Not logged in → show start/login
          return StartPage();
        },
      ),
    );
  }
}