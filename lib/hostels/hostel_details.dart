// ignore_for_file: camel_case_types, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_import, avoid_print, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, duplicate_ignore, unused_local_variable, unnecessary_string_interpolations, avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelhub/Rooms/room_controller.dart';
import 'package:hostelhub/Rooms/room_details.dart';
import 'package:hostelhub/hostels/sing_hostel.dart';
import 'package:hostelhub/services/hostel_details_controller.dart';

import '../Rooms/book_room.dart';
import '../Rooms/update_room.dart';
import '../login/singup/login_controller.dart';
import 'add_room_details.dart';

class hostelDetails extends StatefulWidget {
  const hostelDetails({super.key});

  @override
  State<hostelDetails> createState() => _hostelDetailsState();
}

class _hostelDetailsState extends State<hostelDetails> {
  User? user = FirebaseAuth.instance.currentUser;
  String? email;
  String? hostel_namme;
  String? rStatus;
  String? roomNo;
  String? Roomseating;
  String? bookedseats;
  String? price;
  String? chekstatus;
  int? userCheck;
  int? checkuser;
  // bool? isChecked;
  //   isChecked = false; CheckboxListTile(
  // title: Text('Checkbox'),
  // value: isChecked,
  // onChanged: (value) {
  //   setState(() {
  //     isChecked = value;
  //   });
  // }),
  @override
  void initState() {
    super.initState();
    email = user!.email;
    var userId = user!.uid;
    final userrefernce =
        FirebaseFirestore.instance.collection("users").doc("$userId");
    userrefernce.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if (data != null) {
          userCheck = data['active'] as int;
          print("userCheck:$userCheck");
        }
      }
    });
    FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data();
        var checkuser = data['checkuser'];
        print('checkuser: $checkuser');
      }
    });

    hostel_namme = HostelController().hostelName;
    print(hostel_namme); // Change 'hostelId' to 'hostelName'
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
        backgroundColor: const Color.fromARGB(255, 7, 63, 108),
        title: Center(child: const Text("Rooms list")),
      ),
      bottomNavigationBar: loginController().checkuser == 1 ||
              loginController().checkuser == 2
          ? CurvedNavigationBar(
              color: const Color.fromARGB(255, 7, 63, 108),
              backgroundColor: Colors.white,
              buttonBackgroundColor: Color.fromARGB(255, 7, 80, 140),
              height: 60,
              items: <Widget>[
                Icon(Icons.add, size: 30, color: Colors.white),
              ],
              onTap: (index) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => addHostelRoom()));
                // Handle button tap
              },
            )
          : Container(
              color: const Color.fromARGB(255, 7, 63, 108),
              height: 50,
            ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            // ignore: prefer_adjacent_string_concatenation
            .collection('$hostel_namme' + 'Rooms')
            .orderBy(
              'Roomseating',
            ) // Remove curly braces and fix the collection name
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return Center(child: const CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic>? data =
                  documents[index].data() as Map<String, dynamic>?;

              if (data == null) {
                return Container(child: Text("No related data exist"));
              }
              if (documents.isEmpty) {
                return Center(
                  child: Text(
                    'No rooms yet.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              rStatus = data['Room_status'].toString();
              Roomseating = data['Roomseating'].toString();
              bookedseats = data['bookedseats'].toString();
              price = data['Room_rent'].toString();
              roomNo = data['Room_no'].toString();
              if (Roomseating == bookedseats) {
                // print("bookedseats:$bookedseats");
                // print("Roomseating:$Roomseating");
                chekstatus = "unavalible";
              } else {
                chekstatus = "avalible";
                // print("bookedseats1:$bookedseats");
                // print("Roomseating1:$Roomseating");
              }

              return GestureDetector(
                onTap: () {
                  // if (Roomseating == bookedseats) {
                  //   roomController().avalibilty = "unavalible";
                  // } else {
                  //   roomController().avalibilty = "avalible";
                  // }
                  roomController().roomId = documents[index].id;
                  roomController().total_cpacity =
                      data['Roomseating'].toString();
                  var ccc = roomController().total_cpacity;
                  print("roomcapacity" + ccc!);
                  roomController().seets = data['bookedseats'].toString();
                  print("bookedseats:$bookedseats");
                  if (loginController().checkuser == 1 ||
                      loginController().checkuser == 2) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => roomDetails()));
                  } else {
                    if (roomController().seets ==
                        roomController().total_cpacity) {
                      Fluttertoast.showToast(
                        msg: "Sorry room capacity is full.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 7, 80, 140),
                        textColor: Colors.white,
                      );
                    } else if (userCheck == 0 || userCheck == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoomBooking()));
                    } else {
                      Fluttertoast.showToast(
                        msg: "you have Already one room",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 7, 80, 140),
                        textColor: Colors.white,
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Color.fromARGB(26, 47, 144, 223),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    shadowColor: Color.fromARGB(255, 198, 231, 235)
                        .withOpacity(0.5), // Shadow color
                    elevation: 5,
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(
                            "Room no: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(roomNo ?? ''),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text("Room Status: "),
                              Text(chekstatus ?? ''),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Room seating: "),
                              Text(Roomseating ?? ''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
