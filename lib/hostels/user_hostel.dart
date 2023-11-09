// ignore_for_file: avoid_print, prefer_const_constructors, camel_case_types, unused_import, unused_local_variable, avoid_unnecessary_containers, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, unused_element, unnecessary_cast, prefer_adjacent_string_concatenation

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostelhub/admin/Dasbord/dashbord.dart';
import 'package:hostelhub/hostels/add_hostel.dart';
import 'package:hostelhub/hostels/sing_hostel.dart';

import '../services/hostel_details_controller.dart';

class hostelsUser extends StatefulWidget {
  const hostelsUser({Key? key}) : super(key: key);

  @override
  State<hostelsUser> createState() => _hostelsUserState();
}

class _hostelsUserState extends State<hostelsUser> {
  Future<double?> calculateAverageRating(String hostelName) async {
    final ratings = await FirebaseFirestore.instance
        .collection("$hostelName" + 'ratings')
        .get();
    double totalRating = 0.0;
    int ratingCount = 0;

    for (final rating in ratings.docs) {
      final ratingData = rating.data() as Map<String, dynamic>;
      final userRating = ratingData['rating'] as double;
      totalRating += userRating;
      ratingCount++;
    }

    if (ratingCount > 0) {
      return totalRating / ratingCount;
    }

    return null;
  }

  Widget buildAverageRatingStars(double averageRating) {
    // Create a list of Icon widgets for the stars.
    List<Icon> starIcons = [];
    for (int i = 1; i <= 5; i++) {
      starIcons.add(
        Icon(
          Icons.star,
          color: i <= averageRating ? Colors.yellow : Colors.grey,
        ),
      );
    }

    // Return the row of star icons.
    return Row(
      children: starIcons,
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              return FutureBuilder<double?>(
                future: calculateAverageRating(hostelName),
                builder: (context, ratingSnapshot) {
                  double? averageRating = ratingSnapshot.data;

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
                            offset: Offset(
                                0, 3), // Offset in the x and y directions
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          HostelController().hostelId = documents[index].id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleHostel()),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: Text("$hostelLocation"),
                                ),
                                Container(
                                  child: Text("$hostelEmail"),
                                ),
                                buildAverageRatingStars(averageRating ?? 0.0),
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
          );
        },
      ),
    );
  }
}
