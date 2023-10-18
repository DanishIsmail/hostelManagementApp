// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostelhub/admin/Dasbord/dashbord.dart';
import 'package:hostelhub/services/sesstion_controller.dart';
import 'package:hostelhub/userdashboard/user_dashbord.dart';
import 'navigation.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    checkUserAndNavigate();
  }

  Future<void> checkUserAndNavigate() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    String? email = user?.email;
    int? checkuser;

    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data();
        setState(() {
          checkuser = data['checkuser'];
        });

        Timer(const Duration(seconds: 3), () {
          SessionController().userId = user.uid.toString();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => (checkuser == 1 || checkuser == 2)
                  ? Dashboard()
                  : userDashboard(),
            ),
          );
        });
      }
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navigation(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          height: 400,
          child: Image.asset(
            'assets/images/logo.png',
            width: 400,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
