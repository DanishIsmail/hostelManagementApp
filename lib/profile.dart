// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, avoid_print, deprecated_member_use, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'login/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  final ref = FirebaseFirestore.instance.collection("users");
  File? _image;
  User? user;
  String? url;
  String? userId;
  String? id;
  String? username;
  String? email;
  String? phoneNumber;
  File? Imageurl;

  final auth = FirebaseAuth.instance;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    print("user id: $userId");
    print("user email: ${user?.email}");

    // Retrieve the profile image URL from Firestore and set it to `url`
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      var data = snapshot.data();
      if (data != null) {
        setState(() {
          url = data['profileImage'];
          username = data['username'];
          Imageurl = data['profileImage'];
        });
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await picker.getImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      await _uploadImageToFirebase(_image!);
    }
  }

  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      final userId = user?.uid;
      if (userId != null) {
        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('userimages')
            .child('$userId.jpg');
        await storageRef.putFile(imageFile);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'profileImage': imageUrl});
        setState(() {
          url = imageUrl;
        });
        print('Image uploaded successfully');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
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
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 7, 63, 108),
        height: 50,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: screenHeight * 0.8,
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
                              child: Text("Take Photo"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                _pickImage(ImageSource.gallery);
                              },
                              child: Text('Upload Photo'),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return Dialog(
                                      // Add any dialog content here if needed
                                      child: (_image != null || url != null)
                                          ? (_image != null
                                              ? Image.file(
                                                  _image!,
                                                  height: screenHeight * 0.3,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  url!,
                                                  height: screenHeight * 0.3,
                                                  fit: BoxFit.cover,
                                                ))
                                          : Icon(
                                              Icons.image_not_supported,
                                              size: screenWidth * 0.15,
                                              color: Colors.grey,
                                            ),
                                    );
                                  },
                                );
                              },
                              child: Text('View Photo'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.3,
                      height: screenWidth * 0.3,
                      child: CircleAvatar(
                        radius: screenWidth * 0.2,
                        backgroundColor: Colors.grey,
                        backgroundImage: (_image != null || url != null)
                            ? (_image != null
                                ? FileImage(_image!)
                                : NetworkImage(url!)) as ImageProvider<Object>?
                            : null,
                        child: (_image == null && url == null)
                            ? Icon(
                                Icons.person,
                                size: screenWidth * 0.15,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
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
                        print("${snapshot.error}");
                        return SizedBox();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: const CircularProgressIndicator());
                      }

                      var data = snapshot.data?.data() as Map<String, dynamic>?;

                      if (data == null) {
                        return SizedBox();
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
                        child: Column(
                          children: [
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
                                        width: screenWidth * 0.8,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title:
                                                        Text("Edit Your Name"),
                                                    actions: [
                                                      Column(
                                                        children: [
                                                          TextField(
                                                            controller: name,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Your Username",
                                                              fillColor: Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              filled: true,
                                                              prefixIcon:
                                                                  const Icon(Icons
                                                                      .person),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              var nameuser = name
                                                                  .text; // Get the updated username
                                                              // Update the username in Firestore
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "users")
                                                                  .doc(userId)
                                                                  .update({
                                                                "username":
                                                                    nameuser,
                                                              });

                                                              // Close the AlertDialog
                                                              Navigator.of(ctx)
                                                                  .pop();

                                                              // Update the UI with the new username
                                                              setState(() {
                                                                username =
                                                                    nameuser; // Assuming you have `String username = "";` somewhere
                                                              });
                                                            },
                                                            child: Text("Save"),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.edit),
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
                                        width: screenWidth * 0.8,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.black),
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
                                        width: screenWidth * 0.8,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "Phone",
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
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text(
                                                        "Edit Your Phone Number"),
                                                    actions: [
                                                      Column(
                                                        children: [
                                                          TextField(
                                                            controller:
                                                                phone, // Corrected to use the 'phone' controller
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Your Phone Number",
                                                              fillColor: Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              filled: true,
                                                              prefixIcon:
                                                                  const Icon(Icons
                                                                      .phone_android),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              var phoneno = phone
                                                                  .text; // Get the updated phone number
                                                              // Update the phone number in Firestore
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "users")
                                                                  .doc(userId)
                                                                  .update({
                                                                "uPhone":
                                                                    phoneno,
                                                              });

                                                              // Close the AlertDialog
                                                              Navigator.of(ctx)
                                                                  .pop();

                                                              // Update the UI with the new phone number
                                                              setState(() {
                                                                phoneNumber =
                                                                    phoneno; // Assuming you have `String phoneNumber = "";` somewhere
                                                              });
                                                            },
                                                            child: Text("Save"),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.edit),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 7, 80, 140),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 30),
                      ),
                      onPressed: () {
                        auth.signOut().then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        });
                      },
                      child: Text(
                        "Log out",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
