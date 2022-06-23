import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport_tracking_system/screens/map_screen.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({Key? key}) : super(key: key);

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  dynamic busList = [];

  getBusList() async {
    await FirebaseFirestore.instance
        .collection('bus_data')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          busList.add(doc);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getBusList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Bus List',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            )),
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: busList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    print('${busList[index]['bus_routes']}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(
                            busId: busList[index]['bus_id'],
                            isDriver: false,
                          ),
                        ));
                  },
                  child: Card(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.directions_bus,
                            color: Colors.blue,
                            size: 25,
                          ),
                        ),
                        Expanded(
                            child: Text(
                          ' ${busList[index]['bus_name']}',
                          style: TextStyle(),
                        )),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  )));
            }));
  }
}
