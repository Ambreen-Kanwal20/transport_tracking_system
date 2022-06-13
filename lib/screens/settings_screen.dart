import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transport_tracking_system/screens/welcome_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'alert_dialog.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void initState() {
    super.initState();
  }

  alertDialog() async {
    final action =
        await AlertDialogs.yesCancelDialog(context, 'Logout', 'Are you sure?');
    if (action == DialogsAction.yes) {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            )),
        body: SafeArea(
            child: Container(
                color: Colors.white,
                constraints: const BoxConstraints.expand(),
                margin: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildAccountOption(
                          context: context,
                          icon: Icon(Icons.password,
                              color: Colors.blue, size: 18),
                          title: 'Change Password',
                          route: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePasswordScreen(),
                                ));
                          }),
                      Divider(),
                      buildAccountOption(
                          context: context,
                          icon:
                              Icon(Icons.person, color: Colors.blue, size: 18),
                          title: 'Edit Profile',
                          route: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(),
                                ));
                          }),
                      Divider(),
                      buildAccountOption(
                          context: context,
                          icon: Icon(
                            Icons.help,
                            color: Colors.blue,
                            size: 18,
                          ),
                          title: 'Contact us',
                          route: () {
                            launch(
                                'mailto:support@gmail.com?subject=This is subject Title & body=This is body of Email');
                          }),
                      Divider(),
                      buildAccountOption(
                          context: context,
                          icon:
                              Icon(Icons.logout, color: Colors.blue, size: 18),
                          title: 'Logout',
                          route: () {
                            alertDialog();
                          })
                    ],
                  ),
                ))));
  }

  GestureDetector buildAccountOption(
      {required BuildContext context,
      required icon,
      required String title,
      required route}) {
    return GestureDetector(
        onTap: route,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              icon,
              Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(title,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ))),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.blue,
                size: 30,
              ),
            ],
          ),
        ));
  }
}
