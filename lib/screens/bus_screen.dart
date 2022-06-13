import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({Key? key}) : super(key: key);

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  final BusNameText = TextEditingController();
  final BusDestinationText = TextEditingController();

  bool BusNameValidation = false;
  bool BusDestinationValidation = false;

  void validation() {
    if (BusNameText.text.isEmpty && BusDestinationText.text.isEmpty) {
      setState(() {
        BusNameValidation = true;
        BusDestinationValidation = true;
      });
    } else if (BusNameText.text.isEmpty) {
      setState(() {
        BusNameValidation = true;
        BusDestinationValidation = false;
      });
    } else if (BusDestinationText.text.isEmpty) {
      setState(() {
        BusDestinationValidation = true;
        BusNameValidation = false;
      });
    } else {
      setState(() {
        BusDestinationValidation = false;
        BusNameValidation = false;
      });
      registration();
    }
  }

  registration() async {
    try {
       await FirebaseAuth.instance.signInAnonymously();

      CollectionReference bus_data =
      FirebaseFirestore.instance.collection('bus_data');

      bus_data
          .add({
            'bus_id': FirebaseAuth.instance.currentUser!.uid,
            'bus_name': BusNameText.text,
            'bus_destination': BusDestinationText.text,
            'bus_routes': [],
            'bus_location': "",
            'bus_driver': "",
          })
          .then((value) => print("Bus Added"))
          .catchError((error) => print("Failed to add bus: $error"));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Registered successfully!",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ));
    } on FirebaseAuthException catch (e) {}
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Add Bus',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            )),
        body: Container(
            color: Colors.white,
            constraints: const BoxConstraints.expand(),
            margin: const EdgeInsets.all(15.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20, bottom: 10),
                child: const Text(
                  'Bus Details',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.all(3.0),
                child: TextField(
                  controller: BusNameText,
                  decoration: InputDecoration(
                    errorText:
                        BusNameValidation ? 'Please enter Bus Name' : null,
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 3.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Bus Name",
                    hintText: "Enter Bus Name",
                    labelStyle: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                    prefixIcon: const Icon(Icons.email, size: 20.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.all(3.0),
                child: TextField(
                  controller: BusDestinationText,
                  decoration: InputDecoration(
                    errorText: BusDestinationValidation
                        ? 'Please enter Bus Destination'
                        : null,
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 3.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Bus Destination",
                    hintText: "Enter Bus destination",
                    labelStyle: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                    prefixIcon: const Icon(Icons.email, size: 20.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: GestureDetector(
                  onTap: () {
                    validation();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: const Text('Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ))),
                ),
              ),
            ])));
  }
}
