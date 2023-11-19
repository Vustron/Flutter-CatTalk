// ignore_for_file: avoid_unnecessary_containers, unused_import

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';

//global object for accessing device screen size
late Size mq;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'We Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 19.0,
            fontWeight: FontWeight.bold,
          ),
          color: Color.fromARGB(255, 68, 255, 196),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
