// ignore_for_file: prefer_const_constructors, unnecessary_cast, prefer_interpolation_to_compose_strings, non_constant_identifier_names, camel_case_types, avoid_print, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, sort_child_properties_last, sized_box_for_whitespace

import 'package:hostelhub/payment/payment.dart';
import 'package:hostelhub/payment/paymentpic.dart';
import 'package:hostelhub/payment/paymnet_controller.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../add_compalins.dart';

class userRoomDetails extends StatefulWidget {
  const userRoomDetails({Key? key}) : super(key: key);

  @override
  State<userRoomDetails> createState() => _userRoomDetailsState();
}

class _userRoomDetailsState extends State<userRoomDetails> {
  User? user;
  String? userId;
  String? hostel;
  String? roomId;
  String? roomrent;
  String? roomcapcity;
  int? roombookedseats;
  Timestamp? request_time;
  String? date;
  int? active;
  int? payment;
  bool isRefreshed = false;

  @override
  void initState() {
    super.initState();
    if (!isRefreshed) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          isRefreshed = true;
        });
      });
    }
    user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic>? data =
            docSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          active = data["active"];
        }
      }
    });
  }

  String formatRequestTime(Timestamp? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      date = DateFormat('yyyy-MM-dd ').format(dateTime);
      return DateFormat('HH:mm:ss').format(dateTime);
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('usersBookedDetails')
              .doc(userId)
              .get(),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
          ) {
            print("userid:$userId");
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
            final Map<String, dynamic> dataMap = data as Map<String, dynamic>;
            hostel = dataMap['hostelID'];
            roomId = dataMap['roomId'];
            request_time = dataMap['createdId'];
            payment = dataMap['payment'];
            userpayment().hostelid = dataMap['hostelID'];
            userpayment().roomId = dataMap['roomId'];
            userpayment().uid = dataMap["userId"];
            userpayment().payment = dataMap["payment"];
            userpayment().uid = dataMap["userId"];
            userpayment().username = dataMap["username"];

            FirebaseFirestore.instance
                .collection(hostel! + "Rooms")
                .doc(roomId)
                .get()
                .then((docSnapshot) {
              if (docSnapshot.exists) {
                print("hello");
                Map<String, dynamic>? data =
                    docSnapshot.data() as Map<String, dynamic>?;
                // print(data!['bookedseats']);
                roombookedseats = data?['bookedseats'];
                roomrent = data?['Room_rent'];
                roomcapcity = data?["Roomseating"];
                print("$roomrent");
                print("$roombookedseats");
                print("$roomcapcity");
              }
            });
            return active == 1 || active == 2
                ? Container(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Hostel:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "$hostel",
                                  style: TextStyle(fontSize: 19),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.black),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Romm no:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$roomId",
                                style: TextStyle(fontSize: 19),
                              ),
                            ],
                          ),
                          Divider(color: Colors.black),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Request time:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatRequestTime(request_time),
                                style: TextStyle(fontSize: 19),
                              ),
                            ],
                          ),
                          Divider(color: Colors.black),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Request date:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$date",
                                style: TextStyle(fontSize: 19),
                              ),
                            ],
                          ),
                          Divider(color: Colors.black),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Request staus:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                active == 2 ? "Pending" : "Accepted",
                                style: TextStyle(fontSize: 19),
                              ),
                            ],
                          ),
                          Divider(color: Colors.black),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rent:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$roomrent",
                                style: TextStyle(fontSize: 19),
                              ),
                            ],
                          ),
                          Divider(color: Colors.black),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Capcity:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$roomcapcity",
                                style: TextStyle(fontSize: 19),
                              ),
                            ],
                          ),
                          Divider(color: Colors.black), SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Payment:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                payment == 0 ? "Not Paid" : "paid",
                                style: TextStyle(fontSize: 19),
                              ),
                            ],
                          ),
                          Divider(color: Colors.black),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 10),
                            child: Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: Text(
                                    "Add /veiw complains",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 7, 80, 140),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                addComplains()));
                                  },
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 10),
                            child: Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: Text(
                                    "Payment ",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 7, 80, 140),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    payment == 0
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    payment_method()))
                                        : null;
                                  },
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 10),
                            child: Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: Text(
                                    "Transaction History",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 7, 80, 140),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentPic()));
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 300.0),
                      child: Container(
                        child: Text(
                          "No room Found",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
