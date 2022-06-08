import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isOldPassword = true;
  bool isNewPassword = true;
  bool isConfirmPassword = true;

  final oldPasswordText = TextEditingController();
  final newPasswordText = TextEditingController();
  final confirmPasswordText = TextEditingController();
  bool oldPasswordValidation = false;
  bool newPasswordValidation = false;
  bool confirmPasswordValidation = false;

  void validation() {
    if (oldPasswordText.text.isEmpty &&
        newPasswordText.text.isEmpty &&
        confirmPasswordText.text.isEmpty) {
      setState(() {
        oldPasswordValidation = true;
        newPasswordValidation = true;
        confirmPasswordValidation = true;
      });
    } else if (oldPasswordText.text.isEmpty) {
      setState(() {
        oldPasswordValidation = true;
        newPasswordValidation = false;
        confirmPasswordValidation = false;
      });
    } else if (newPasswordText.text.isEmpty) {
      setState(() {
        oldPasswordValidation = false;
        newPasswordValidation = true;
        confirmPasswordValidation = false;
      });
    } else if (confirmPasswordText.text.isEmpty) {
      setState(() {
        oldPasswordValidation = false;
        newPasswordValidation = false;
        confirmPasswordValidation = true;
      });
    } else if (newPasswordText.text != confirmPasswordText.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          "New Password and Confirm Password does not match.",
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ));
    } else {
      changePassword();
    }
  }

  void _oldPasswordView() {
    setState(() {
      isOldPassword = !isOldPassword;
    });
  }

  void _newPasswordView() {
    setState(() {
      isNewPassword = !isNewPassword;
    });
  }

  void _confirmPasswordView() {
    setState(() {
      isConfirmPassword = !isConfirmPassword;
    });
  }

  changePassword() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      await currentUser!.updatePassword(newPasswordText.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          "New Password has been Set.",
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ));
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          "$e",
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ));
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
              'Change Password',
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
                          'assets/changepassword.jpg',
                          height: 230,
                          width: 200,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              child: TextField(
                                controller: oldPasswordText,
                                obscureText: isOldPassword,
                                decoration: InputDecoration(
                                  errorText: oldPasswordValidation
                                      ? 'Please enter old password'
                                      : null,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 3.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: "Enter Your Old Password",
                                  labelText: "Old Password",
                                  labelStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                  ),
                                  prefixIcon: Icon(Icons.password, size: 20.0),
                                  suffixIcon: GestureDetector(
                                    onTap: _oldPasswordView,
                                    child: Icon(Icons.visibility),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              child: TextField(
                                controller: newPasswordText,
                                obscureText: isNewPassword,
                                decoration: InputDecoration(
                                  errorText: newPasswordValidation
                                      ? 'Please enter new password'
                                      : null,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 3.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: "Enter New Password",
                                  labelText: "Set Password",
                                  labelStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                  ),
                                  prefixIcon: Icon(Icons.password, size: 20.0),
                                  suffixIcon: GestureDetector(
                                    onTap: _newPasswordView,
                                    child: Icon(Icons.visibility),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(height: 10.0),
                        Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              child: TextField(
                                controller: confirmPasswordText,
                                obscureText: isConfirmPassword,
                                decoration: InputDecoration(
                                  errorText: confirmPasswordValidation
                                      ? 'Please re-enter password'
                                      : null,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 3.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: "Re-Enter Your Password",
                                  labelText: "Confirm Password",
                                  labelStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                  ),
                                  prefixIcon: Icon(Icons.password, size: 20.0),
                                  suffixIcon: GestureDetector(
                                    onTap: _confirmPasswordView,
                                    child: Icon(Icons.visibility),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(height: 40.0),
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
                            padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text('Continue',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ))),
                          ),
                        ),
                      ]),
                ))));
  }
}
