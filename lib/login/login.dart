// ignore_for_file: unused_import, avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelhub/forgetPassword/fogetpasword.dart';
import 'package:hostelhub/login/singup/login_controller.dart';
import '../userdashboard/user_dashbord.dart';
import '../admin/Dasbord/dashbord.dart';
import 'singup/singup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    String password = passwordController.text;

    if (validateEmail(email) && validatePassword(password)) {
      // Valid email and password, perform login logic here
      print('Login Successful');
    } else {
      // Invalid email or password
      print('Invalid email or password');
    }
  }

  User? user;
  String? email;
  bool isPasswordVisible = false;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    print("user email: ${user?.email}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(context) {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Text("Enter your credentials to login"),
      ],
    );
  }

  Widget _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.email, color: Colors.grey),
          ),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.lock, color: Colors.grey),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              child: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ),
          obscureText: !isPasswordVisible,
          controller: passwordController,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            var loginEmail = emailController.text.trim();
            var loginPassword = passwordController.text.trim();

            try {
              final UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: loginEmail,
                password: loginPassword,
              );
              final User? firebaseUser = userCredential.user;

              if (validateEmail(loginEmail) &&
                  validatePassword(loginPassword)) {
                if (firebaseUser != null) {
                  FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: loginEmail)
                      .get()
                      .then((querySnapshot) {
                    if (querySnapshot.docs.isNotEmpty) {
                      final docSnapshot = querySnapshot.docs.first;
                      Map<String, dynamic> data = docSnapshot.data();
                      int checkuser = data['checkuser'];
                      print('checkuser: $checkuser');

                      if (checkuser == 1 || checkuser == 2) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      } else if (checkuser == 0) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => userDashboard()),
                        );
                      } else {
                        print('Invalid checkuser value');
                      }
                    } else {
                      print('User document does not exist');
                    }
                  });
                }
                print('Login Successful');
              } else {
                print('Invalid email or password');
              }
            } on FirebaseAuthException catch (e) {
              Fluttertoast.showToast(
                msg: "$e",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 7, 80, 140),
                textColor: Colors.white,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 7, 80, 140),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => forgetPassword()),
        );
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Color.fromARGB(255, 7, 80, 140)),
      ),
    );
  }

  Widget _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Color.fromARGB(255, 7, 80, 140)),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegScreen()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
