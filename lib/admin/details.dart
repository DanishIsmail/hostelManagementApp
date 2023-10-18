// ignore_for_file: camel_case_types, prefer_final_fields, avoid_print, prefer_const_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, unnecessary_cast, sort_child_properties_last

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class allRommsdetails extends StatefulWidget {
  const allRommsdetails({Key? key}) : super(key: key);

  @override
  State<allRommsdetails> createState() => _allRommsdetailsState();
}

class _allRommsdetailsState extends State<allRommsdetails> {
  TextEditingController _searchController = TextEditingController();
  String selectedValue = 'Select------';
  String? hostel;
  String? roomId;
  String? date;
  int? active;
  int? payment;
  User user = FirebaseAuth.instance.currentUser!;
  String? userId;
  String email = '';
  int? checkuser;

  List<String> hostelNames = [];

  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    email = user.email!;
    fetchCheckUser();
  }

  Future<void> fetchCheckUser() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data();
      setState(() {
        checkuser = data['checkuser'];
        print('checkuser: $checkuser');
        fetchHostelNames();
      });
    }
  }

  Future<void> fetchHostelNames() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('hostel').get();

      setState(() {
        hostelNames = snapshot.docs
            .map((doc) =>
                (doc.data() as Map<String, dynamic>)['hostelName']
                    ?.toString() ??
                "")
            .toList();

        // Add "Select one of them" as the first item in the list
        hostelNames.insert(0, "Select------");

        // Check if the selectedValue exists in hostelNames, if not, set it to the default value
        if (!hostelNames.contains(selectedValue)) {
          selectedValue = "Select------";
        }
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Stream<QuerySnapshot> getStream() {
    if (_searchController.text.isEmpty) {
      if (selectedValue == "Select------") {
        // If no search text and "Select------" is chosen, get all data with Active: 1
        return FirebaseFirestore.instance
            .collection("usersBookedDetails")
            .where("Active", isEqualTo: 1)
            .snapshots();
      } else {
        // If no search text but a hostel is selected, get data for that hostel with Active: 1
        return FirebaseFirestore.instance
            .collection("usersBookedDetails")
            .where("Active", isEqualTo: 1)
            .where("hostelID", isEqualTo: selectedValue)
            .snapshots();
      }
    } else {
      if (selectedValue == "Select------") {
        // If there is search text but no hostel is selected, filter data by search text only
        return FirebaseFirestore.instance
            .collection("usersBookedDetails")
            .where("Active", isEqualTo: 1)
            .where("username", isEqualTo: _searchController.text.trim())
            .snapshots();
      } else {
        // If there is search text and a hostel is selected, filter data by both criteria
        return FirebaseFirestore.instance
            .collection("usersBookedDetails")
            .where("Active", isEqualTo: 1)
            .where("hostelID", isEqualTo: selectedValue)
            .where("username", isEqualTo: _searchController.text.trim())
            .snapshots();
      }
    }
  }

  void _payFee(String userId, String roomId) {
    try {
      // Update payment status to 1
      FirebaseFirestore.instance
          .collection("usersBookedDetails")
          .doc(userId)
          .update({"payment": 1}).then((_) {
        print("Payment status updated to 1 for userId: $userId");

        // Schedule to reset payment status after 30 days
        Timer(Duration(days: 30), () {
          FirebaseFirestore.instance
              .collection("usersBookedDetails")
              .doc(userId)
              .update({"payment": 0}).then((_) {
            print(
                "Payment status reset to 0 for userId: $userId after 30 days");
          }).catchError((error) {
            print("Error resetting payment status: $error");
          });
        });
      }).catchError((error) {
        print("Error updating payment status: $error");
      });
    } catch (e) {
      print("Exception while updating payment status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(
                        () {}); // Trigger a rebuild when the text in the search bar changes.
                  },
                  decoration: InputDecoration(
                    hintText: "Search by username",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(
                            () {}); // Trigger a rebuild when the search bar is cleared.
                      },
                    ),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue == "Select------") {
                      selectedValue = "Select------";
                      setState(() {});
                    } else {
                      selectedValue = newValue!;
                    }
                  });
                },
                items:
                    hostelNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              StreamBuilder(
                stream: getStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print("Error: ${snapshot.error}");
                    return const Text("An error occurred while fetching data.");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic>? data =
                          documents[index].data() as Map<String, dynamic>?;

                      if (data == null) {
                        return const Text("No related data exist");
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(26, 47, 144, 223),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Hostel Name: " +
                                          data['hostelID'].toString()),
                                      Text("Room no: " +
                                          data['roomId'].toString()),
                                      Text("Username: " +
                                          data['username'].toString()),
                                    ],
                                  ),
                                ),
                              ),
                              if (checkuser == 2)
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        DateTime now = DateTime.now();
                                        String currentMonthName =
                                            DateFormat.MMMM().format(now);
                                        String year =
                                            DateFormat.y().format(now);
                                        String paymentDocId =
                                            "$currentMonthName$year";

                                        userId = data['userId'].toString();
                                        int rent = 0;
                                        int payment = 0;

                                        var hostelId =
                                            data['hostelID'].toString();

                                        try {
                                          // Fetch room data
                                          DocumentSnapshot roomDocSnapshot =
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      "${hostelId}Rooms")
                                                  .doc(
                                                      data['roomId'].toString())
                                                  .get();

                                          if (roomDocSnapshot.exists) {
                                            Map<String, dynamic> roomData =
                                                roomDocSnapshot.data()
                                                    as Map<String, dynamic>;

                                            // Assuming 'Room_rent' field exists in your room data
                                            // Convert the fetched string to an integer
                                            rent = int.parse(
                                                roomData['Room_rent']
                                                    as String);
                                          }

                                          // Fetch payment data
                                          DocumentSnapshot paymentDocSnapshot =
                                              await FirebaseFirestore.instance
                                                  .collection('payment')
                                                  .doc(paymentDocId)
                                                  .get();

                                          if (paymentDocSnapshot.exists) {
                                            Map<String, dynamic> paymentData =
                                                paymentDocSnapshot.data()
                                                    as Map<String, dynamic>;

                                            // Assuming 'payment' field exists in your payment data
                                            payment = paymentData['payment']
                                                    as int? ??
                                                0;
                                          }

                                          // Calculate new payment by adding rent
                                          payment += rent;

                                          // Get a reference to the payment document for the current month
                                          DocumentReference paymentDocRef =
                                              FirebaseFirestore.instance
                                                  .collection('payment')
                                                  .doc(paymentDocId);

                                          // Update or create the payment document
                                          paymentDocRef.set({
                                            'payment': payment,
                                            "Month": currentMonthName,
                                            "year": year,
                                          });

                                          // Call your _payFee function
                                          _payFee(userId!,
                                              data['roomId'].toString());
                                        } catch (e) {
                                          print("Error: $e");
                                        }
                                      },
                                      child: Text(
                                        data['payment'] == 0
                                            ? "Unpaid"
                                            : "Paid",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 7, 80, 140),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Container(),
                              SizedBox(width: 10),
                              checkuser == 2
                                  ? ElevatedButton(
                                      onPressed: () {
                                        userId = data['userId'].toString();
                                        FirebaseFirestore.instance
                                            .collection("usersBookedDetails")
                                            .doc(userId)
                                            .update({"Active": 0});
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(userId)
                                            .update({"active": 2});
                                        var hostelId =
                                            data['hostelID'].toString();

                                        FirebaseFirestore.instance
                                            .collection("${hostelId}Rooms")
                                            .doc(data['roomId'].toString())
                                            .get()
                                            .then((docSnapshot) {
                                          if (docSnapshot.exists) {
                                            Map<String, dynamic>? data =
                                                docSnapshot.data()
                                                    as Map<String, dynamic>?;
                                            if (data != null) {
                                              print("hello");
                                              int currentSeats =
                                                  data['bookedseats'] as int;
                                              print(
                                                  "currentSeats:$currentSeats");

                                              FirebaseFirestore.instance
                                                  .collection(
                                                      "${hostelId}Rooms")
                                                  .doc(
                                                      data['roomId'].toString())
                                                  .update({
                                                'bookedseats': currentSeats + 1
                                              });
                                            }
                                          }
                                        });
                                        FirebaseFirestore.instance
                                            .collection("${hostelId}Rooms")
                                            .doc(data['roomId'].toString())
                                            .update({"active": 2});
                                      },
                                      child: Text(
                                        "DisActive",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 7, 80, 140),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
