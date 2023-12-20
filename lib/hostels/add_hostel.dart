// ignore_for_file: camel_case_types, deprecated_member_use, avoid_print, prefer_const_constructors, sized_box_for_whitespace, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../Rooms/add_room_details.dart';

class newHostel extends StatefulWidget {
  const newHostel({Key? key}) : super(key: key);

  @override
  State<newHostel> createState() => _newHostelState();
}

class _newHostelState extends State<newHostel> {
  TextEditingController hostelnameController = TextEditingController();
  TextEditingController hostelContactController = TextEditingController();
  TextEditingController hostelLocationController = TextEditingController();
  TextEditingController hostelEmailController = TextEditingController();
  TextEditingController hostelDescriptionController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  File? _image;
  String? imageUrl;
  String? hostelName;
  bool isHostelNameExist = false;
  final picker = ImagePicker();
  CollectionReference reference =
      FirebaseFirestore.instance.collection("hostel");

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }

    try {
      final imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('hostel_images')
          .child('$imageName.jpg');
      await storageRef.putFile(_image!);
      imageUrl = await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await picker.getImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 7, 80, 140),
        title: Center(child: Text("Add Hostel")),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
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
                      backgroundImage: (_image != null || imageUrl != null)
                          ? (_image != null
                                  ? FileImage(_image!)
                                  : NetworkImage(imageUrl!))
                              as ImageProvider<Object>?
                          : null,
                      child: (_image == null && imageUrl == null)
                          ? Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                _inputFields(context),
              ],
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
          controller: hostelnameController,
          decoration: InputDecoration(
            hintText: "Hostel Name",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.home),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: hostelLocationController,
          decoration: InputDecoration(
            hintText: "Hostel Location",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.location_city_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: hostelContactController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Contact",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.call),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: hostelEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Email",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: hostelDescriptionController,
          decoration: InputDecoration(
            hintText: "Description",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.description),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
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
            hostelName = hostelnameController.text.trim().toUpperCase();
            var contact = hostelContactController.text.trim();
            var email = hostelEmailController.text.trim();
            var location = hostelLocationController.text.trim();
            var description = hostelDescriptionController.text.trim();

            await FirebaseFirestore.instance
                .collection("hostel")
                .where('hostelName', isEqualTo: hostelName)
                .get()
                .then((querySnapshot) {
              if (querySnapshot.docs.isNotEmpty) {
                setState(() {
                  isHostelNameExist = true;
                });
              }
            });

            await _uploadImage();
            if (_image != null &&
                hostelName != "" &&
                contact != "" &&
                email != "" &&
                location != "" &&
                description != "") {
              _uploadImage();
              if (!isHostelNameExist) {
                if ((_image != null || imageUrl != null)) {
                  Fluttertoast.showToast(
                    msg: "Please upload an image ",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color.fromARGB(255, 7, 80, 140),
                    textColor: Colors.white,
                  );
                  await FirebaseFirestore.instance.collection('hostel').add({
                    'hostelName': hostelName,
                    'hostelContact': contact,
                    'hostelEmail': email,
                    'hostelLocation': location,
                    'description': description,
                    'imageUrl': imageUrl ?? '',
                  });
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => addHostelRoom()),
                  );
                }
              } else if (hostelName == null &&
                  contact == null &&
                  email == null &&
                  location == null &&
                  description == null) {
                Fluttertoast.showToast(
                  msg: "Hostel with this name already exists",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color.fromARGB(255, 7, 80, 140),
                  textColor: Colors.white,
                );
              }
            } else {
              if (_image == null) {
                Fluttertoast.showToast(
                  msg: "Please upload an image",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color.fromARGB(255, 7, 80, 140),
                  textColor: Colors.white,
                );
              } else {
                Fluttertoast.showToast(
                  msg: "Please fill all feilds",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color.fromARGB(255, 7, 80, 140),
                  textColor: Colors.white,
                );
              }
            }
          },
          child: Text(
            "Next",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
