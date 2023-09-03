// ignore_for_file: file_names, camel_case_types, avoid_unnecessary_containers, prefer_const_constructors, avoid_print, unused_element, unused_local_variable, prefer_const_constructors_in_immutables, unused_import, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelhub/Rooms/room_controller.dart';
import 'package:hostelhub/services/hostel_details_controller.dart';

import 'hostels.dart';

class addHostelRoom extends StatefulWidget {
  addHostelRoom({super.key});

  @override
  State<addHostelRoom> createState() => _addHostelRoomState();
}

class _addHostelRoomState extends State<addHostelRoom> {
  TextEditingController roomnoController = TextEditingController();
  TextEditingController roomSeatingController = TextEditingController();
  TextEditingController roomStatus = TextEditingController();
  TextEditingController rentController = TextEditingController();
  // ignore: non_constant_identifier_names
  String? hostelname = HostelController().hostelName;
  void _showErrorToast(var err) {
    Fluttertoast.showToast(
      msg: "$err",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
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
        title: Center(child: const Text("Add Rooms")),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    child: Text("Please enter all given crandentials"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _inputFields(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _inputFields(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 40,
        ),
        TextField(
          controller: roomnoController,
          decoration: InputDecoration(
            hintText: "Room no",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.numbers),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: roomSeatingController,
          decoration: InputDecoration(
            hintText: "Seating capacity",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.bed),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: roomStatus,
          decoration: InputDecoration(
            hintText: "status",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.book_rounded),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
          // obscureText: true,
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: rentController,
          decoration: InputDecoration(
            hintText: "Payment",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.payment),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
          // obscureText: true,
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 7, 80, 140),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () async {
              var aroomno = roomnoController.text.trim();
              var aroomStatus = roomStatus.text.trim();
              var aroomRent = rentController.text.trim();
              var aroomSeating = roomSeatingController.text.trim();
              int bookedSeats = 0;

              try {
                await FirebaseFirestore.instance
                    .collection('${hostelname}Rooms')
                    .doc(aroomno)
                    .set({
                  'Room_no': aroomno,
                  'Roomseating': aroomSeating,
                  'Room_rent': aroomRent,
                  'Room_status': aroomStatus,
                  "bookedseats": bookedSeats,
                  'hostelReference': HostelController().hostelId,
                });
              } catch (error) {
                _showErrorToast(error);
              }
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Hostels()));
            },
            child: Text(
              "Save",
              style: TextStyle(fontSize: 20),
            ))
      ],
    );
  }
}
