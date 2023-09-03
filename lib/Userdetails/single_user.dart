// ignore_for_file: deprecated_member_use, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unused_import, library_private_types_in_public_api, unused_element, unused_local_variable, avoid_print, unused_label, empty_statements, prefer_interpolation_to_compose_strings, body_might_complete_normally_nullable, prefer_const_literals_to_create_immutables, override_on_non_overriding_member

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hostelhub/login/login.dart';
import 'package:hostelhub/services/sesstion_controller.dart';
import 'package:image_picker/image_picker.dart';

class SingelUser extends StatefulWidget {
  const SingelUser({Key? key}) : super(key: key);

  @override
  _SingelUserState createState() => _SingelUserState();
}

class _SingelUserState extends State<SingelUser> {
  final ref = FirebaseFirestore.instance.collection("users");
  File? _image;
  User? user;
  String? url;
  String? userId;
  String? id;
  String? username;
  String? email;
  String? phoneNumber;

  final auth = FirebaseAuth.instance;
  final picker = ImagePicker();

  @override
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await newMethod(source);
    if (pickedImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('userimages')
          .child(username! + '.jpg');
      setState(() {
        _image = File(pickedImage.path);
      });
      await ref.putFile(pickedImage as File);
      url = await ref.getDownloadURL();
      _updateUserDetails();
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<PickedFile?> newMethod(ImageSource source) async {
    return await ImagePicker().getImage(source: source);
  }

  Future<void> _updateUserDetails() async {
    try {
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'profileImage': url});
        print('User details updated successfully');
      }
    } catch (e) {
      print('Error updating user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Color.fromARGB(255, 222, 216, 216),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Choose an option"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              _pickImage(ImageSource.camera);
                            },
                            child: Text("Camera"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              _pickImage(ImageSource.gallery);
                            },
                            child: Text('Gallery'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: 130,
                    height: 130,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 50),
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

                    print("id: $id");
                    print("username: $username");
                    print("email: $email");
                    print("phone number: $phoneNumber");

                    return Container(
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  child: Icon(Icons.person),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Container(
                                    width: 340,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.0, color: Colors.black),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Name",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "$username",
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //email
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  child: Icon(Icons.email),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Container(
                                    width: 340,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.0, color: Colors.black),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Email",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "$email",
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //phone no
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  child: Icon(Icons.phone),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Container(
                                    width: 340,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.0, color: Colors.black),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "PHone",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "$phoneNumber",
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
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
}
