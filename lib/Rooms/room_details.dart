// ignore_for_file: camel_case_types, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, non_constant_identifier_names, unused_local_variable, prefer_adjacent_string_concatenation, avoid_print, unrelated_type_equality_checks

import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelhub/Rooms/addbookingdetails.dart';
import 'package:hostelhub/Rooms/room_controller.dart';
import 'package:hostelhub/Rooms/update_room.dart';

import '../login/singup/login_controller.dart';
import '../services/hostel_details_controller.dart';

class roomDetails extends StatefulWidget {
  const roomDetails({super.key});

  @override
  State<roomDetails> createState() => _roomDetailsState();
}

class _roomDetailsState extends State<roomDetails> {
  String? hostelname = HostelController().hostelName;
  String? roomId = roomController().roomId;
  User? user = FirebaseAuth.instance.currentUser;
  String? roomno;
  String? roomCapcity;
  String? roomStatus;
  String? roomPrice;
  int? booked_seats;
  // var seats = roomController().seets;
  // var total_cpacity = roomController().total_cpacity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            loginController().checkuser == 1 || loginController().checkuser == 2
                ? AppBar(
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: Color.fromARGB(255, 7, 80, 140),
                    title: Text("Room details"),
                  )
                : null,
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('${hostelname}Rooms')
                  .doc(roomId)
                  .get(),
              builder: (
                BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot,
              ) {
                print(roomId);
                if (snapshot.hasError) {
                  Fluttertoast.showToast(
                    msg: "${snapshot.error}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color.fromARGB(255, 7, 80, 140),
                    textColor: Colors.white,
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('Document does not exist');
                }
                var data = snapshot.data!.data();

                if (data == null) {
                  return Text('No data available');
                }
                final Map<String, dynamic> dataMap =
                    data as Map<String, dynamic>;
                roomPrice = dataMap["Room_rent"];
                roomCapcity = dataMap["Roomseating"];
                roomStatus = dataMap["Room_status"];
                roomno = dataMap["Room_no"];
                booked_seats = dataMap["bookedseats"];
                roomController().rent = roomPrice;

                return Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Room no:",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "$roomno",
                                style: TextStyle(
                                  fontSize: 19,
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Rent:",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "$roomPrice",
                                style: TextStyle(
                                  fontSize: 19,
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Seating capacity:",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "$roomCapcity",
                                style: TextStyle(
                                  fontSize: 19,
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Room status:",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                (roomController().seets! ==
                                        roomController().total_cpacity)
                                    ? "UnAvailable"
                                    : "Available",
                                style: TextStyle(
                                  fontSize: 19,
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                loginController().checkuser ==
                                                            1 ||
                                                        loginController()
                                                                .checkuser ==
                                                            2
                                                    ? updateRooom()
                                                    : bookerdetails()))
                                  },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 7, 80, 140),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                loginController().checkuser == 1 ||
                                        loginController().checkuser == 2
                                    ? "Update"
                                    : "Book Room",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}
