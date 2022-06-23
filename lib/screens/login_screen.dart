import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transport_tracking_system/screens/admin_screen.dart';
import 'package:transport_tracking_system/screens/bottom_tabs.dart';
import 'package:transport_tracking_system/screens/forgot_password_screen.dart';
import 'package:transport_tracking_system/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isAdmin;
  final bool isStudent;

  const LoginScreen({
    Key? key,
    required this.isAdmin,
    required this.isStudent,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  bool emailValidation = false;
  bool passwordValidation = false;

  void validation() {
    if (emailText.text.isEmpty && passwordText.text.isEmpty) {
      setState(() {
        emailValidation = true;
        passwordValidation = true;
      });
    } else if (emailText.text.isEmpty) {
      setState(() {
        emailValidation = true;
        passwordValidation = false;
      });
    } else if (passwordText.text.isEmpty) {
      setState(() {
        passwordValidation = true;
        emailValidation = false;
      });
    } else {
      setState(() {
        passwordValidation = false;
        emailValidation = false;
      });
      userLogin();
    }
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  void userLogin() async {
    print(emailText.text);
    print(passwordText.text);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailText.text, password: passwordText.text);
      print('user creadentails $userCredential');
      if (widget.isAdmin == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AdminScreen()));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => BottomTabsScreen(isStudent: false)));
      }

      print('$userCredential userCredential');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Logged In successfully!",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      print('error $e');
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "No user found for that email!",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Wrong password provided for that user!",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              color: Colors.white,
              constraints: const BoxConstraints.expand(),
              margin: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                  child: Form(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/slider2.png',
                        height: 210,
                        width: 200,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 20, bottom: 10),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextField(
                          controller: emailText,
                          decoration: InputDecoration(
                            errorText:
                                emailValidation ? 'Please enter E-mail' : null,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 3.0),
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
                            errorText: passwordValidation
                                ? 'Please enter password'
                                : null,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 3.0),
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
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const ForgotPasswordScreen();
                          }));
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
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
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Text('Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  )),
                            ),
                          )),
                      const SizedBox(
                        height: 20.0,
                      ),
                      widget.isStudent == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  const Text(" Don't have an account?",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      )),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const SignUpScreen(
                                          isDriver: false,
                                        );
                                      }));
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  )
                                ])
                          : SizedBox(
                              height: 1,
                            ),
                    ]),
              ))),
        ));
  }
}
