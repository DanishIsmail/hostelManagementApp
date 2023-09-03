// ignore_for_file: camel_case_types, library_private_types_in_public_api, prefer_const_constructors, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelhub/Rooms/room_controller.dart';
import 'package:hostelhub/Rooms/room_details.dart';
import 'package:hostelhub/services/hostel_details_controller.dart';

class updateRooom extends StatefulWidget {
  const updateRooom({Key? key}) : super(key: key);

  @override
  _updateRooomState createState() => _updateRooomState();
}

class _updateRooomState extends State<updateRooom> {
  TextEditingController roomnoController = TextEditingController();
  TextEditingController roomSeatingController = TextEditingController();
  TextEditingController rentController =
      TextEditingController(text: roomController().rent);
  String? hostelname = HostelController().hostelName;
  String? roomId = roomController().roomId;

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
        title: Text("Update Room"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Please enter new rent"),
                  const SizedBox(height: 10),
                  _inputFields(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Center(child: Text("Room no: $roomId")),
        const SizedBox(height: 10),
        TextField(
          controller: rentController,
          decoration: InputDecoration(
            hintText: "Rent",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.payment),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 7, 80, 140),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            var rent = rentController.text;
            // var seats = roomSeatingController.text;
            if (rent.isNotEmpty) {
              updateAllRooms(rent);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => roomDetails()),
              );
            } else {
              Fluttertoast.showToast(
                msg: "Please enter all fields",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 7, 80, 140),
                textColor: Colors.white,
              );
            }
          },
          child: Text(
            "Save",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  Future<void> updateAllRooms(String newRentValue) async {
    var roomsRef = FirebaseFirestore.instance.collection("${hostelname}Rooms");
    var querySnapshot = await roomsRef.get();

    for (var doc in querySnapshot.docs) {
      var roomId = doc.id;
      // Perform the update for each document
      await roomsRef.doc(roomId).update({
        "Room_rent": newRentValue,
        // Add more fields to update here if needed
      });
    }
  }
}
