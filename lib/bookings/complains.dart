// ignore_for_file: avoid_print, sort_child_properties_last, prefer_const_constructors, sized_box_for_whitespace, camel_case_types, non_constant_identifier_names, use_key_in_widget_constructors, avoid_unnecessary_containers, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class allComplains extends StatefulWidget {
  const allComplains({Key? key});

  @override
  State<allComplains> createState() => _allComplainsState();
}

class _allComplainsState extends State<allComplains> {
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
                      QueryDocumentSnapshot document = documents[index];
                      Map<String, dynamic>? data =
                          document.data() as Map<String, dynamic>?;

                      if (data == null) {
                        return Container(
                          child: Text("no complain yet"),
                        );
                      }
                      userCommnet = data['complain'];
                      userName = data['username'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 300,
                                child: ListTile(
                                  title: Text("$userName"),
                                  subtitle: Text("$userCommnet"),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  try {
                                    String documentId =
                                        document.id; // Get the document ID
                                    FirebaseFirestore.instance
                                        .collection('complains')
                                        .doc(documentId)
                                        .delete();
                                    print('Document deleted successfully');
                                  } catch (e) {
                                    print('Error deleting document: $e');
                                  }
                                },
                                child: Text("Delete"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 7, 80, 140),
                                  shape: const StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Divider(
                              height: 3,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
