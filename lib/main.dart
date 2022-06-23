import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transport_tracking_system/screens/add_user_screen.dart';
import 'package:transport_tracking_system/screens/admin_screen.dart';
import 'package:transport_tracking_system/screens/add_bus_screen.dart';
import 'package:transport_tracking_system/screens/bus_list_screen.dart';
import 'package:transport_tracking_system/screens/change_password_screen.dart';
import 'package:transport_tracking_system/screens/map_screen.dart';
import 'package:transport_tracking_system/screens/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:transport_tracking_system/screens/signup_screen.dart';
import 'package:transport_tracking_system/screens/splash_screen.dart';
import 'package:transport_tracking_system/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: SplashScreen()));
}
