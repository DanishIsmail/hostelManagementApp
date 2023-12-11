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
  TextEditingController commentController = TextEditingController();
  User? user;
  String? userId;
  String? username;
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
        title: Text("Complain"),
        backgroundColor: Color.fromARGB(255, 7, 80, 140),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('complains')
                  .where("uid", isEqualTo: userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    QueryDocumentSnapshot document = documents[index];
                    Map<String, dynamic>? data =
                        documents[index].data() as Map<String, dynamic>?;
                    var description = data!["complain"];
                    var status = data["status"];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: status == 1
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
                                    // Update status to indicate in-progress
                                    await FirebaseFirestore.instance
                                        .collection("complains")
                                        .doc(document.id)
                                        .update({"status": 1});
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
                                    // Update status to indicate resolved
                                    await FirebaseFirestore.instance
                                        .collection("complains")
                                        .doc(document.id)
                                        .update({"status": 2});
                                  },
                                  child: Text('Resolved'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 7, 80, 140),
                                    shape: const StadiumBorder(),
                                  ),
                                )
                              else if (status == 3)
                                ElevatedButton(
                                  onPressed: () async {
                                    // Update status to indicate resolved
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
                  },
                );
              },
            ),
          ),
          Divider(
            height: 2,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: null,
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Add new complain",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 9, 99, 117),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    var comment = commentController.text.trim();
                    if (comment.isNotEmpty) {
                      FirebaseFirestore.instance.collection("complains").add({
                        "username": username,
                        "complain": comment,
                        "uid": userId,
                        "status": 0,
                        "email": user?.email,
                      });
                      commentController.clear();
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
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: addComplains(),
    ),
  );
}
