import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transport_tracking_system/screens/admin_screen.dart';
import 'package:transport_tracking_system/screens/welcome_screen.dart';
import 'bottom_tabs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () => checkLoginState());
  }

  checkLoginState() {
    print('check status called');
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      print('user ${user?.email}');
      if (user == null) {
        print('User is currently signed out!');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      } else if (user.email == 'admin@admin.com') {
        print('Admin is already login!');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminScreen()));
      } else {
        print('User is already signed in!');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BottomTabsScreen(isStudent: true)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return initWidget(context);
    return Scaffold(
        body: Center(
            child: Container(
      child: Icon(Icons.route_outlined, size: 70),
    )));
  }
}
