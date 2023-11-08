// ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, avoid_print, sort_child_properties_last, prefer_adjacent_string_concatenation

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostelhub/bookings/booking_controller.dart';

class applications extends StatefulWidget {
  const applications({Key? key});

  @override
  State<applications> createState() => _applicationsState();
}

class _applicationsState extends State<applications> {
  String? roomId;
  String? hostelId;
  late DocumentReference roomref;
  String? userId; // Declare room
  late DocumentReference userref;
  late DocumentReference bookingref;

  @override
  void initState() {
    // chekstatus = bookingController().bookingStatus as int;
    // roomId = roomController().roomId;
    // hostelId = HostelController().hostelName.toString();
    super.initState();
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
        title: const Text("Booking Applications"),
        backgroundColor: const Color.fromARGB(255, 7, 63, 108),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("usersBookedDetails")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return const Text("An error occurred while fetching data.");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic>? data =
                  documents[index].data() as Map<String, dynamic>?;

              if (data == null) {
                return const Text("No related data exist");
              }

              return data['Active'] == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: Color.fromARGB(26, 47, 144, 223),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          shadowColor: Color.fromARGB(255, 198, 231, 235)
                              .withOpacity(0.5), // Shadow color
                          elevation: 5,
                          child: ListTile(
                            title: Text(data['username'].toString()),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hostel Name: " +
                                    data['hostelID'].toString()),
                                Text("Room no: " + data['roomId'].toString()),
                                Row(
                                  children: [
                                    if (data['Active'] == 0)
                                      Container(
                                        child: ElevatedButton(
                                          onPressed: () => {
                                            roomId = data['roomId'].toString(),
                                            hostelId =
                                                data['hostelID'].toString(),
                                            // room ref
                                            roomref = FirebaseFirestore.instance
                                                .collection(
                                                    "$hostelId" + "Rooms")
                                                .doc(roomId),
                                            userId = data['userId'].toString(),
                                            // roombooking ref
                                            bookingref = FirebaseFirestore
                                                .instance
                                                .collection(
                                                    "usersBookedDetails")
                                                .doc(userId),
                                            bookingref
                                                .get()
                                                .then((docSnapshot) {
                                              if (docSnapshot.exists) {
                                                Map<String, dynamic>? data =
                                                    docSnapshot.data() as Map<
                                                        String, dynamic>?;
                                                if (data != null) {
                                                  print("hello");
                                                  bookingref
                                                      .update({'Active': 1});
                                                  setState(() {
                                                    bookingController()
                                                            .bookingStatus =
                                                        data['Active'] as int;
                                                  });
                                                }
                                              }
                                            }),
                                            if (userId != null)
                                              {
                                                userref = FirebaseFirestore
                                                    .instance
                                                    .collection("users")
                                                    .doc(userId),
                                              },
                                            roomref.get().then((docSnapshot) {
                                              if (docSnapshot.exists) {
                                                Map<String, dynamic>? data =
                                                    docSnapshot.data() as Map<
                                                        String, dynamic>?;
                                                if (data != null) {
                                                  print("hello");
                                                  int currentSeats =
                                                      data['bookedseats']
                                                          as int;
                                                  print(
                                                      "currentSeats:$currentSeats");
                                                  roomref.update({
                                                    'bookedseats':
                                                        currentSeats + 1
                                                  });
                                                  userref.update({
                                                    "active": 1,
                                                  });
                                                }
                                              }
                                            }),
                                          },
                                          child: const Text("Accept"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromARGB(255, 7, 80, 140),
                                            shape: const StadiumBorder(),
                                          ),
                                        ),
                                      )
                                    else if (data['Active'] == 1)
                                      Container(
                                        child: Text(
                                            "This application is accepted"),
                                      ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    if (data['Active'] == 0)
                                      Container(
                                        child: ElevatedButton(
                                          onPressed: () => {
                                            {
                                              roomId =
                                                  data['roomId'].toString(),
                                              hostelId =
                                                  data['hostelID'].toString(),
                                              // room ref
                                              roomref = FirebaseFirestore
                                                  .instance
                                                  .collection(
                                                      "$hostelId" + "Rooms")
                                                  .doc(roomId),
                                              userId =
                                                  data['userId'].toString(),
                                              // roombooking ref
                                              bookingref = FirebaseFirestore
                                                  .instance
                                                  .collection(
                                                      "usersBookedDetails")
                                                  .doc(userId),
                                              bookingref
                                                  .get()
                                                  .then((docSnapshot) {
                                                if (docSnapshot.exists) {
                                                  Map<String, dynamic>? data =
                                                      docSnapshot.data() as Map<
                                                          String, dynamic>?;
                                                  if (data != null) {
                                                    print("hello");
                                                    bookingref.update({
                                                      'Active': 2,
                                                    });
                                                  }
                                                }
                                              }),
                                              if (userId != null)
                                                {
                                                  userref = FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(userId),
                                                },
                                              roomref.get().then((docSnapshot) {
                                                if (docSnapshot.exists) {
                                                  Map<String, dynamic>? data =
                                                      docSnapshot.data() as Map<
                                                          String, dynamic>?;
                                                  if (data != null) {
                                                    print("hello");
                                                    int currentSeats =
                                                        data['bookedseats']
                                                            as int;
                                                    print(
                                                        "currentSeats:$currentSeats");
                                                    roomref.update({
                                                      'bookedseats':
                                                          currentSeats + 1
                                                    });
                                                    userref.update({
                                                      "active": 1,
                                                    });
                                                  }
                                                }
                                              }),
                                            }
                                            // roomref.update({
                                            //   "bookedseats": capacity! + 1,
                                            // })
                                          },
                                          child: const Text(
                                            "Reject",
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromARGB(255, 7, 80, 140),
                                            shape: const StadiumBorder(),
                                          ),
                                        ),
                                      )
                                    else if (data['Active'] == 2)
                                      Container(
                                        child:
                                            Text("This application is rejeted"),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container();
            },
          );
        },
      ),
    );
  }
}
