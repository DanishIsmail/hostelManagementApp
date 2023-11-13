// ignore_for_file: avoid_print, sort_child_properties_last, prefer_const_constructors, sized_box_for_whitespace, camel_case_types, non_constant_identifier_names, use_key_in_widget_constructors, avoid_unnecessary_containers, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, unused_local_variable

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
  String? phoneno;

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
        phoneno = data?["uPhone"];
        print(username);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double oneThirdHeight = screenHeight / 1.5;
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
        title: Text("Complain"),
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
              height: oneThirdHeight,
              color: Color.fromARGB(26, 241, 241, 241),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('complains')
                    // .where('status', isNotEqualTo: 2)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  if (documents.isEmpty) {
                    return Center(
                      child: Text(
                        'No complaints yet.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot document = documents[index];
                        Map<String, dynamic>? data =
                            documents[index].data() as Map<String, dynamic>?;
                        var phoneno = data!["phone"];
                        var description = data["complain"];
                        var status = data["status"];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: data["status"] == 1
                                  ? Color.fromARGB(255, 7, 80, 140)
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID:${index + 1}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Name: ' + data["username"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Divider(color: Colors.grey),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text('Email: ' + data["email"]),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Description: $description'),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  if (status == 0 || status == 1)
                                    ElevatedButton(
                                      onPressed: () async {
                                        // await FirebaseFirestore.instance
                                        //     .collection("complains")
                                        //     .doc(document.id)
                                        //     .update({"status": 1});
                                        // setState(() {});
                                      },
                                      child: Text('In Progress'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 7, 80, 140),
                                        shape: const StadiumBorder(),
                                      ),
                                    )
                                  else if (status == 2)
                                    ElevatedButton(
                                        onPressed: () async {
                                          // await FirebaseFirestore.instance
                                          //     .collection("complains")
                                          //     .doc(document.id)
                                          //     .update({"status": 2});
                                        },
                                        child: Text('Resolved'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 7, 80, 140),
                                          shape: const StadiumBorder(),
                                        ))
                                  else if (status == 3)
                                    ElevatedButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection("complains")
                                            .doc(document.id)
                                            .update({"status": 3});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 7, 80, 140),
                                        shape: const StadiumBorder(),
                                      ),
                                      child: Text('Resolved'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      });
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
                        hintText: "Add new complain",
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
                        "uid": userId,
                        "status": 0,
                        "email": user?.email,
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
