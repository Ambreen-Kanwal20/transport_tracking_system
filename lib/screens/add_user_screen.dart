import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  final bool isDriver;

  const AddUserScreen({Key? key, required this.isDriver}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  List<String> busName = <String>[];
  String? value;
  String DropdownValue = 'Bus Name';

  bool button = false;
  var busID;

  bool isHiddenPassword = true;
  final nameText = TextEditingController();
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  bool nameValidation = false;
  bool emailValidation = false;
  bool passwordValidation = false;

  var res = FirebaseFirestore.instance.collection('bus_data');

  void validation() {
    if (nameText.text.isEmpty &&
        emailText.text.isEmpty &&
        passwordText.text.isEmpty) {
      setState(() {
        nameValidation = true;
        emailValidation = true;
        passwordValidation = true;
      });
    } else if (nameText.text.isEmpty) {
      setState(() {
        emailValidation = false;
        passwordValidation = false;
        nameValidation = true;
      });
    } else if (emailText.text.isEmpty) {
      setState(() {
        emailValidation = true;
        passwordValidation = false;
        nameValidation = false;
      });
    } else if (passwordText.text.isEmpty) {
      setState(() {
        emailValidation = false;
        passwordValidation = true;
        nameValidation = false;
      });
    } else {
      registration();
    }
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  registration() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailText.text,
        password: passwordText.text,
      );
      CollectionReference user_details =
          FirebaseFirestore.instance.collection('user_details');
      user_details
          .add({
            'full_name': nameText.text,
            'email': emailText.text,
            'password': passwordText.text,
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'payment status': false,
            'isDriver?': widget.isDriver,
            'bus_id': busID,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      print(user_details);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Registered successfully!",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ));

      UserCredential adminLogin = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: 'admin@admin.com', password: 'admin1');
      print(adminLogin);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Password provided is too weak.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Account already exists for that email.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ));
      }
    } catch (e) {}
    Navigator.pop(context);
  }

  data() {
    res.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["bus_name"] == value) {
          busID = doc["bus_id"];

          if (button == false) {
            busID = doc["bus_id"];
            print('bus id $busID');
          } else {
            res.doc(doc.id).update({'bus_driver': nameText.text});
          }
        }
      });
    });
  }

  getBusName() async {
    res.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          busName.add(doc['bus_name']);
          print('Add bus names ');
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getBusName();
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
              'Add User',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            )),
        body: SafeArea(
            child: Container(
          color: Colors.white,
          constraints: const BoxConstraints.expand(),
          margin: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Image.asset(
                  'assets/signup.png',
                  height: 230,
                  width: 200,
                ),
                Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                      controller: nameText,
                      decoration: InputDecoration(
                        errorText:
                            nameValidation ? 'Please enter your name' : null,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 3.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Enter your name",
                        labelText: "Full Name",
                        labelStyle: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                        prefixIcon: const Icon(Icons.person, size: 20.0),
                      ),
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.all(3.0),
                  child: TextField(
                    controller: emailText,
                    decoration: InputDecoration(
                      errorText: emailValidation ? 'Please enter E-mail' : null,
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: "E-mail",
                      hintText: "Enter your Email ID",
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
                    child: TextField(
                      controller: passwordText,
                      obscureText: isHiddenPassword,
                      decoration: InputDecoration(
                        errorText:
                            passwordValidation ? 'Please enter password' : null,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 3.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Enter your password",
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                        prefixIcon: const Icon(Icons.security, size: 20.0),
                        suffixIcon: GestureDetector(
                          onTap: _togglePasswordView,
                          child: const Icon(Icons.visibility),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            isExpanded: true,
                            value: value,
                            hint: Text(
                              DropdownValue,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            items: busName.map(buildMenuItem).toList(),
                            onChanged: (value) => setState(() {
                                  this.value = value;
                                  data();
                                })))),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: GestureDetector(
                    onTap: () {
                      button = true;
                      if (button == true) {
                        validation();
                        data();
                      }
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
              ])),
        )));
  }

  DropdownMenuItem<String> buildMenuItem(String busName) => DropdownMenuItem(
      value: busName,
      child: Text(busName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          )));
}
