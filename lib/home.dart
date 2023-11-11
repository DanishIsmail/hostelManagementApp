// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, unused_import, avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostelhub/Userdetails/users_details.dart';
import 'package:hostelhub/admin/wardens.dart';
import 'package:hostelhub/bookings/applications.dart';
// import 'package:hostelhub/hostels/hostelDetails.dart';
import 'package:hostelhub/hostels/hostels.dart';
import 'package:hostelhub/admin/Dasbord/dashbord.dart';
import 'package:hostelhub/payment/payments.dart';

import 'complains/complains.dart';
import 'hostels/hostel_details.dart';
import 'transaction/transactions.dart';

// import 'hostels/hostel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  String? userId;
  String email = '';
  int? checkuser;
  @override
  void initState() {
    super.initState();
    fetchCheckUser();
  }

  Future<void> fetchCheckUser() async {
    userId = user.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((snapshot) {
      var data = snapshot.data();
      if (data != null) {
        setState(() {
          checkuser = data['checkuser'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // Ensures the children expand to the full width
            children: [
              GestureDetector(
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Hostels()))
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/hostellist.png'), // Replace with your own image path
                        fit: BoxFit.fill,
                        // colorFilter: ColorFilter.mode(
                        //     Colors.grey.withOpacity(0.2), BlendMode.dstATop),
                      )),
                  height: 175,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => applications()))
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage("assets/images/Application.jpg"),
                      fit: BoxFit
                          .fill, // Ensure the image covers the entire container
                      // colorFilter: ColorFilter.mode(
                      //     Colors.grey.withOpacity(0.2), BlendMode.dstATop),
                    ),
                  ),
                  height: 175,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color: Color.fromARGB(167, 114, 203, 241),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/Complain1.png'), // Replace with your own image path
                        fit: BoxFit.fill,
                        // colorFilter: ColorFilter.mode(
                        //     Colors.grey.withOpacity(0.2), BlendMode.dstATop),
                      )),
                  height: 175,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => allComplains()));
                },
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Payment()))
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/payment.png'), // Replace with your own image path
                        fit: BoxFit.fill,
                        // colorFilter: ColorFilter.mode(
                        //     Colors.grey.withOpacity(0.2), BlendMode.dstATop),
                      )),
                  child: Center(
                    child: Text(
                      'Payments',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  height: 175,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              checkuser == 2
                  ? GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // color: Color.fromARGB(167, 114, 203, 241),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/transaction1.png'), // Replace with your own image path
                              fit: BoxFit.fill,
                              // colorFilter: ColorFilter.mode(
                              //     Colors.grey.withOpacity(0.2), BlendMode.dstATop),
                            )),
                        height: 175,
                        child: Center(
                            child: Text(
                          "Transaction",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionsScreen()));
                      },
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              checkuser == 1
                  ? GestureDetector(
                      onTap: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => warden()))
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/warden1.png'), // Replace with your own image path
                              fit: BoxFit.fill,
                              // colorFilter: ColorFilter.mode(
                              //     Colors.grey.withOpacity(0.2), BlendMode.dstATop),
                            )),
                        height: 175,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
