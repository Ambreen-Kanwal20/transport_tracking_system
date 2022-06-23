import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transport_tracking_system/screens/bus_list_screen.dart';
import 'package:transport_tracking_system/screens/settings_screen.dart';
import 'map_screen.dart';

class BottomTabsScreen extends StatefulWidget {
  final bool isStudent;

  const BottomTabsScreen({Key? key, required this.isStudent}) : super(key: key);

  @override
  State<BottomTabsScreen> createState() => _BottomTabsScreenState();
}

class _BottomTabsScreenState extends State<BottomTabsScreen> {
  int _currentIndex = 0;

  List _tabs = [];

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  checkUserStatus() async {
    var userId = await FirebaseAuth.instance.currentUser!.uid;
    print('scnz $userId');

    await FirebaseFirestore.instance
        .collection('user_details')
        .where('uid', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print('user object ${doc['isDriver?']}');
        if (doc['isDriver?']) {
          setState(() {
            _tabs.add(MapScreen(
              busId: doc['bus_id'],
              isDriver: true,
            ));
            _tabs.add(SettingsScreen());
          });
        } else {
          setState(() {
            _tabs.add(BusListScreen());
            _tabs.add(SettingsScreen());
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs.length > 0 ? _tabs[_currentIndex] : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
