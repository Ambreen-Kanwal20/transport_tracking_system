import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailText = TextEditingController();
  bool emailValidation = false;

  void validation() {
    if (emailText.text.isEmpty) {
      setState(() {
        emailValidation = true;
      });
    }
    forgetPassword();
  }

  forgetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailText.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          "Reset password email has been sent to your email.",
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("No user found for that email.",
                style: TextStyle(
                  fontSize: 12,
                ))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Forget Password',
            style: TextStyle(fontSize: 17.0, color: Colors.white),
          ),
        ),
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
                        'assets/forgotpassword.png',
                        height: 250,
                        width: 230,
                      ),
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        child: TextField(
                          controller: emailText,
                          decoration: InputDecoration(
                            errorText:
                                emailValidation ? 'Please enter E-mail' : null,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 3.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: "E-mail",
                            hintText: "Enter your Email ID",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                            prefixIcon: Icon(Icons.email, size: 20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.blue,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: GestureDetector(
                              onTap: () {
                                validation();
                              },
                              child: Text('Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ))),
                        ),
                      ),
                    ])))));
  }
}
