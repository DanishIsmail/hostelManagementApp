// ignore_for_file: avoid_print, sort_child_properties_last, prefer_const_constructors, sized_box_for_whitespace, camel_case_types, non_constant_identifier_names, use_key_in_widget_constructors, avoid_unnecessary_containers, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class addComplains extends StatefulWidget {
  const addComplains({Key? key});

  @override
  State<addComplains> createState() => _addComplainsState();
}

class _addComplainsState extends State<addComplains> {
  TextEditingController CommentController = TextEditingController();
  User? user;
  String? userId;
  String? username;
  String? userCommnet;
  String? userName;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    print("userId:$userId");
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        username = data?["username"];
        print(username);
      }
    });
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
        title: Text("Add Complain"),
        backgroundColor: Color.fromARGB(255, 7, 80, 140),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 7, 63, 108),
        height: 50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                child: Text(
                  "Your Complains",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
                ),
              ),
            ),
            Container(
              height: 500,
              color: Color.fromARGB(26, 241, 241, 241),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('complains')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No complaints yet.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic>? data =
                          documents[index].data() as Map<String, dynamic>?;

                      if (data == null) {
                        return Container(
                          child: Text("no complain"),
                        );
                      }
                      userCommnet = data['complain'];
                      userName = data['username'];

                      return SingleChildScrollView(
                        child: userName == username
                            ? Column(
                                children: [
                                  ListTile(
                                    title: Text("$userName"),
                                    subtitle: Text("$userCommnet"),
                                  ),
                                  Divider(
                                    height: 3,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            : Container(),
                      );
                    },
                  );
                },
              ),
            ),
            Divider(
              height: 2,
              color: Colors.black,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 70,
                      maxWidth: 300,
                    ),
                    child: TextField(
                      maxLines: null,
                      controller: CommentController,
                      decoration: InputDecoration(
                        hintText: "complain",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 9, 99, 117)),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    var comment = CommentController
                        .text; // Get the text value from the TextEditingController
                    if (comment != null && comment.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection("complains")
                          .doc()
                          .set({
                        "username": username,
                        "complain": comment,
                      });
                      CommentController
                          .clear(); // Clear the text field after sending the comment
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Icon(
                    Icons.send_sharp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
