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
  var value;

  bool isHiddenPassword = true;
  final nameText = TextEditingController();
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  bool nameValidation = false;
  bool emailValidation = false;
  bool passwordValidation = false;


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
        'isDriver?' : widget.isDriver,

      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      print(userCredential);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Registered successfully!",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ));

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
                                nameValidation
                                    ? 'Please enter your name'
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey,
                                      width: 3.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: "Enter your name",
                                labelText: "Full Name",
                                labelStyle: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                                prefixIcon: const Icon(
                                    Icons.person, size: 20.0),
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
                              errorText: emailValidation
                                  ? 'Please enter E-mail'
                                  : null,
                              border: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.grey,
                                    width: 3.0),
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
                                passwordValidation
                                    ? 'Please enter password'
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey,
                                      width: 3.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: "Enter your password",
                                labelText: "Password",
                                labelStyle: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                                prefixIcon: const Icon(
                                    Icons.security, size: 20.0),
                                suffixIcon: GestureDetector(
                                  onTap: _togglePasswordView,
                                  child: const Icon(Icons.visibility),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 10.0,
                        ),

                        widget.isDriver == true ?
                            DropdownButton<String>(
                                items: [
                                  // List Of DropdownMenuItem
                                  DropdownMenuItem<String>(
                                    // Value Returned
                                    value: "Bus 1",
                                    // Value Displayed
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text('Bus 1'),
                                      ),
                                    ),
                                  ),

                                  DropdownMenuItem<String>(
                                    // Value Returned
                                    value: "Bus 2",
                                    // Value Displayed
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text('Bus 2'),
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) =>
                                    setState(() => this.value = value),
                                hint: Text("Bus Name",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    )))
                        :
                        const SizedBox(
                          height: 20.0,
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0),
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
}
