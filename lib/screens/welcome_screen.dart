import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      constraints: const BoxConstraints.expand(),
      margin: const EdgeInsets.all(15),
      child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(padding: EdgeInsets.all(20)),
        Image.asset(
          'assets/welcome.png',
          height: 200,
          width: 300,
        ),
        SizedBox(
          height: 1.0,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Welcome to System',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        DropdownButton<String>(
            items: [
              // List Of DropdownMenuItem
              DropdownMenuItem<String>(
                // Value Returned
                value: "Login as a Student",
                // Value Displayed
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    child: Text('Login as a Student'),
                  ),
                ),
              ),

              DropdownMenuItem<String>(
                // Value Returned
                value: "Login as a Driver",
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //     returned    ));
                    },
                    child: Text('Login as a Driver'),
                  ),
                ),
              ),
            ],
            onChanged: (value) => setState(() => this.value = value),
            hint: Text("Login",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )))
      ])),
    )));
  }
}
