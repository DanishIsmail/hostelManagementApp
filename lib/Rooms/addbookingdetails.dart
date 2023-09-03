// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, prefer_const_constructors, unused_local_variable, avoid_print, camel_case_types, avoid_unnecessary_containers, unnecessary_null_comparison, non_constant_identifier_names, dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelhub/Rooms/room_controller.dart';
import 'package:hostelhub/services/hostel_details_controller.dart';

import '../hostels/hostel_details.dart';

class bookerdetails extends StatefulWidget {
  const bookerdetails({Key? key}) : super(key: key);

  @override
  State<bookerdetails> createState() => _bookerdetailsState();
}

class _bookerdetailsState extends State<bookerdetails> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController uPhonenoController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? userId;
  String? id;
  String? username;
  String? email;
  User? user;
  int? userActive;
  String? phoneNumber;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    print("user id: $userId");
    print("user email: ${user?.email}");
    registerFCMToken();
  }

  Future<void> registerFCMToken() async {
    // Get the FCM token for this device
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM token: $fcmToken");

    // Save the FCM token to Firestore for the current user
    if (fcmToken != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': fcmToken});
    }
  }

  Future<void> sendNotificationToServer() async {
    // Placeholder function to send a notification request to the server-side
    // You need to implement the server-side component to handle this request
    // and send notifications to specific users based on their FCM tokens.
    // This part is not implemented in the client-side (Flutter) code.
    try {
      // Fetch the FCM token for the current user from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      String? fcmToken = userSnapshot.get('fcmToken');

      // Prepare the notification message
      const String notificationTitle = "New Booking Request";
      const String notificationBody = "A new room booking request is received.";

      // Here, you would send the request to your server-side component to send the notification
      // For demonstration purposes, we'll print the message.
      print('Sending notification request to server...');
      print('Title: $notificationTitle');
      print('Body: $notificationBody');
      print('FCM Token: $fcmToken');

      // Placeholder: Simulate a server response (you need to implement server-side logic)
      bool isNotificationSent = true;

      if (isNotificationSent) {
        Fluttertoast.showToast(
          msg: "Notification sent successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 7, 80, 140),
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to send notification.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 7, 80, 140),
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new, // Replace with the desired back icon
              // You can use any icon from the Icons class or your custom icon.
              // For example: Icons.arrow_back, Icons.close, etc.
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color.fromARGB(255, 7, 63, 108),
          title: Center(child: const Text("Room Booking")),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CircularProgressIndicator());
                    }

                    var data = snapshot.data?.data() as Map<String, dynamic>?;

                    if (data == null) {
                      return const SizedBox();
                    }

                    id = data['userId'] as String?;
                    username = data['username'] as String?;
                    email = data['email'] as String?;
                    phoneNumber = data['uPhone'] as String?;
                    userActive = data['active'];

                    print("userActive: $userActive");
                    print("id: $id");
                    print("username: $username");
                    print("email: $email");
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              hintText: "$username",
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "$email",
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: uPhonenoController,
                            decoration: InputDecoration(
                              hintText: "$phoneNumber",
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.phone_android),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              hintText: "Cnic",
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.pages_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            // obscureText: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: cnicController,
                            decoration: InputDecoration(
                              hintText: "Address",
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.location_pin),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            // obscureText: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              var username = usernameController.text.trim();
                              var uemail = emailController.text.trim();
                              var cnic = cnicController.text.trim();
                              var uphone = uPhonenoController.text.trim();
                              var address = addressController.text.trim();

                              try {
                                print("userActive:$userActive");
                                if (userActive == 1) {
                                  print("docoment Alredy exist");
                                } else {
                                  if (username != null &&
                                      uemail != null &&
                                      cnic != null &&
                                      uphone != null &&
                                      address != null) {
                                    await FirebaseFirestore.instance
                                        .collection('usersBookedDetails')
                                        .doc(userId)
                                        .set({
                                      "username": username,
                                      "email": uemail,
                                      "createdId": DateTime.now(),
                                      "uPhone": uphone,
                                      "cnic": cnic,
                                      "userId": userId,
                                      "roomId": roomController().roomId,
                                      "address": address,
                                      "hostelID": HostelController().hostelName,
                                      "Active": 0,
                                      "payment": 0,
                                    });
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc("$userId")
                                        .update({
                                      "active": 2,
                                    });
                                    await sendNotificationToServer();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              hostelDetails()),
                                    );
                                  }
                                }
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: "$e",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Color.fromARGB(255, 7, 80, 140),
                                  textColor: Colors.white,
                                );
                              }
                            },
                            child: const Text(
                              "Book Room",
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 7, 80, 140),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: const [
        SizedBox(
          height: 60,
        ),
        Text(
          "Room Booking",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter details to get booked you own room"),
      ],
    );
  }
}
