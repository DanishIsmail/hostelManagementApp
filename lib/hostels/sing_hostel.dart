// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, sized_box_for_whitespace, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelhub/Userdetails/userdetails_controller.dart';
import 'package:hostelhub/rating/rating.dart';

import '../login/singup/login_controller.dart';
import '../services/hostel_details_controller.dart';
import 'hostel_details.dart';

class SingleHostel extends StatefulWidget {
  SingleHostel({Key? key});

  @override
  State<SingleHostel> createState() => _SingleHostelState();
}

class _SingleHostelState extends State<SingleHostel> {
  User? user = FirebaseAuth.instance.currentUser;
  String? hostel_name;
  String? documentId;
  String? hostelContact;
  String? hostelEmail;
  String? hostelLocation;
  String? description;
  String? hostelName;
  String? email;
  String? imageUrl;
  int? checkuser;

  @override
  void initState() {
    super.initState();
    documentId = HostelController().hostelId;
    email = user!.email;
    FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data();
        checkuser = data['checkuser'];
        userController().username = data['username'];
        print('checkuser: $checkuser');
        loginController().checkuser = checkuser;
      }
    });
    hostel_name = HostelController().hostelName;
    print(hostel_name);
    print("alisuserid:" + email!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Color.fromARGB(255, 7, 80, 140),
        title: Text('Hostel Details'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('hostel')
              .doc(documentId)
              .get(),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
          ) {
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

            hostelContact = dataMap['hostelContact'];
            hostelName = dataMap['hostelName'];
            hostelEmail = dataMap['hostelEmail'];
            hostelLocation = dataMap['hostelLocation'];
            description = dataMap['description'];
            imageUrl = dataMap['imageUrl'];
            HostelController().hostelName = hostelName;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: imageUrl != null
                          ? Container(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  imageUrl!,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Image.network(
                              "https://thumbs.dreamstime.com/b/backpackers-hostel-modern-bunk-beds-dorm-room-twelve-people-inside-79935795.jpg"),
                    ),
                    ListTile(
                      title: Text('Hostel Name'),
                      subtitle: Text('$hostelName'),
                    ),
                    ListTile(
                      title: Text('Address'),
                      subtitle: Text('$hostelLocation'),
                    ),
                    ListTile(
                      title: Text('Contact'),
                      subtitle: Text('$hostelContact'),
                    ),
                    ListTile(
                      title: Text('Email'),
                      subtitle: Text('$hostelEmail'),
                    ),
                    ListTile(
                      title: Text('Description'),
                      subtitle: Text('$description'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RatingApp(),
                              ),
                            )
                          },
                          child: checkuser == 1 || checkuser == 2
                              ? Text(
                                  "Review Feadback",
                                  style: TextStyle(fontSize: 20),
                                )
                              : Text(
                                  "Give Feadback",
                                  style: TextStyle(fontSize: 20),
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 7, 80, 140),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: (checkuser == 1 || checkuser == 2)
                              ? const Text(
                                  "Rooms Details",
                                  style: TextStyle(fontSize: 20),
                                )
                              : const Text(
                                  "Select Rooms",
                                  style: TextStyle(fontSize: 20),
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 7, 80, 140),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          onPressed: () {
                            if (checkuser == 1 ||
                                checkuser == 2 ||
                                checkuser == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => hostelDetails(),
                                ),
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "You don't have permission to access this.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Color.fromARGB(255, 7, 80, 140),
                                textColor: Colors.white,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
