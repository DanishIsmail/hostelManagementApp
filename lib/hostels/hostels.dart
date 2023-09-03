// ignore_for_file: avoid_print, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hostelhub/hostels/add_hostel.dart';
import 'package:hostelhub/hostels/sing_hostel.dart';

import '../services/hostel_details_controller.dart';

class Hostels extends StatefulWidget {
  const Hostels({Key? key}) : super(key: key);

  @override
  State<Hostels> createState() => _HostelsState();
}

class _HostelsState extends State<Hostels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 80, 140),
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
        title: const Text("Hostel list"),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromARGB(255, 7, 80, 140),
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color.fromARGB(255, 7, 80, 140),
        height: 60,
        items: const <Widget>[
          Icon(Icons.add, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const newHostel()));
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('hostel').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;

              String hostelLocation = data['hostelLocation'];
              String hostelName = data['hostelName'];
              String hostelContact = data['hostelContact'];
              String hostelEmail = data['hostelEmail'];
              String? imageUrl = data['imageUrl'];
              print("object22");
              print("imageurl:$imageUrl");

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(26, 47, 144, 223),
                    borderRadius: BorderRadius.circular(
                        8), // You can adjust the radius as needed
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 198, 231, 235)
                            .withOpacity(0.5), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset:
                            Offset(0, 3), // Offset in the x and y directions
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      HostelController().hostelId = documents[index].id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SingleHostel()),
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      "https://thumbs.dreamstime.com/b/backpackers-hostel-modern-bunk-beds-dorm-room-twelve-people-inside-79935795.jpg",
                                      fit: BoxFit.fill,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "$hostelName",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: Text("$hostelLocation"),
                            ),
                            Container(
                              child: Text("$hostelEmail"),
                            )
                          ],
                        )
                      ],
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
