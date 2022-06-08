import 'package:flutter/material.dart';
import 'package:transport_tracking_system/screens/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:transport_tracking_system/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}
