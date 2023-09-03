// ignore_for_file: prefer_const_constructors, unused_element, override_on_non_overriding_member, avoid_unnecessary_containers, non_constant_identifier_names, avoid_print, unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hostelhub/Rooms/room_controller.dart';
import 'package:hostelhub/Rooms/room_details.dart';

class RoomBooking extends StatefulWidget {
  const RoomBooking({super.key});

  @override
  State<RoomBooking> createState() => _RoomBookingState();
}

class _RoomBookingState extends State<RoomBooking> {
  @override
  var seats = roomController().seets;
  var total_cpacity = roomController().total_cpacity;
  // var avalible = roomController().avalibilty;
  // _oops() {
  //   print("seats:$seats");
  //   print("total_cpacity:$total_cpacity");
  //   if (seats == total_cpacity) {
  //     return Center(
  //         child: Container(
  //       child: Text(
  //         "Soory Room Capacity is Full",
  //         style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //       ),
  //     ));
  //   }
  // }

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
          title: Center(child: const Text("Room Booking")),
        ),
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 7, 63, 108),
          height: 50,
        ),
        body: roomDetails());
  }
}
