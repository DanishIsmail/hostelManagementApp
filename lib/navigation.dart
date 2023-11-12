// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_element, no_leading_underscores_for_local_identifiers, unused_import, sized_box_for_whitespace

import 'package:flutter/material.dart';

import 'login/login.dart';
import 'login/singup/singup.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    _loginInfo(context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Already have an account?",
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Color.fromARGB(255, 7, 80, 140)),
              ))
        ],
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/background2.png'),
          // image: NetworkImage(
          //     "https://www.nextportland.com/wp-content/uploads/2015/08/nw_portland_hostel_dz2_img_01.jpg"), // image: AssetImage('/assets/images/splashimage.jpg'),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  alignment: Alignment.topLeft,
                  width: 200,
                  // color: Colors.red,
                  child: Image.asset(
                    'assets/images/logo2.png',
                    color: Colors.white,
                    width: 150,
                    height: 150,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Find your perfect place to stay",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    // fontFamily: 'Sanif'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 5),
                child: Container(
                  child: Text(
                    "Find your hostel and trevel any where you want with us",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 7, 80, 140),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      "Sign up",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              _loginInfo(context),
            ],
          ),
        ),
      ),
    );
  }
}
