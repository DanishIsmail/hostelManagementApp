// ignore_for_file: avoid_print, prefer_const_constructors, duplicate_ignore, unused_local_variable, camel_case_types, avoid_unnecessary_containers
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class forgetPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool validateEmail(String value) {
    // Simple email validation using regular expression
    String emailPattern =
        r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(value);
  }

  bool validatePassword(String value) {
    // Simple password validation, you can modify this based on your requirements
    return value.length >= 6;
  }

  void login() {
    String email = emailController.text.trim();

    if (validateEmail(email)) {
      // Valid email and password, perform login logic here
      print('Login Successful');
    } else {
      // Invalid email or password
      print('Invalid email or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(children: [
              Container(
                child: Column(children: const [
                  Text(
                    "Forgot Pasworrd",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text("Enter your credential to login"),
                ]),
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                child: _inputField(context),
              )
              // _header(context),
              // _inputField(context),
            ]),
          ),
        ),
      ),
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              // ignore: prefer_const_constructors
              prefixIcon:
                  Icon(Icons.email, color: Color.fromARGB(255, 7, 80, 140))),
          controller: emailController,
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 7, 80, 140),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Forgot Password",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }
}
