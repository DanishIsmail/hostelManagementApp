// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController comments = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  String? userId;
  String username = '';
  String userComment = '';
  String userName = '';
  String email = '';

  int? checkuser;

  @override
  void initState() {
    super.initState();
    email = user.email!;
    fetchCheckUser();
  }

  Future<void> fetchCheckUser() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data();
      setState(() {
        checkuser = data['checkuser'];
        print('checkuser: $checkuser');
      });
    }
  }

  Future<void> fetchUserData(String userId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        username = data?["username"] ?? '';
        email = data?["email"] ?? '';
        print(username);
        print("email: $email");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double oneThirdHeight = screenHeight / 3;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: oneThirdHeight,
              // color: Color.fromARGB(26, 47, 144, 223),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comments')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                  if (documents.isEmpty) {
                    return Center(
                      child: Text(
                        'No comments yet.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      height: 3,
                      color: Colors.black,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      QueryDocumentSnapshot document = documents[index];
                      Map<String, dynamic>? data =
                          documents[index].data() as Map<String, dynamic>?;

                      if (data == null) {
                        return Container(
                          child: Text("no comment yet"),
                        );
                      }
                      userComment = data['comment'];
                      userName = data['username'];

                      if (checkuser == 1 || checkuser == 2) {
                        return Column(
                          children: [
                            Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              color: Color.fromARGB(26, 47, 144, 223),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              shadowColor: Color.fromARGB(255, 198, 231, 235)
                                  .withOpacity(0.5), // Shadow color
                              elevation: 5,
                              child: ListTile(
                                leading: Container(
                                  width: 30,
                                  alignment: Alignment.topLeft,
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text(userName),
                                subtitle: Text(userComment),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    try {
                                      String documentId =
                                          document.id; // Get the document ID
                                      FirebaseFirestore.instance
                                          .collection('comments')
                                          .doc(documentId)
                                          .delete();
                                      print('Document deleted successfully');
                                    } catch (e) {
                                      print('Error deleting document: $e');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 7, 80, 140),
                                  ),
                                  child: Text("Delete"),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              color: Color.fromARGB(26, 47, 144, 223),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              shadowColor: Color.fromARGB(255, 198, 231, 235)
                                  .withOpacity(0.5), // Shadow color
                              elevation: 5,
                              child: ListTile(
                                leading: Container(
                                  width: 30,
                                  alignment: Alignment.topLeft,
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text(userName),
                                subtitle: Text(userComment),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: 300,
                    child: TextField(
                      controller: comments,
                      decoration: InputDecoration(
                        hintText: "comment",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: true,
                        prefixIcon: Icon(Icons.comment, color: Colors.grey),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await fetchUserData(user.uid); // Fetch user details
                        var comment = comments.text;
                        if (comment.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection("comments")
                              .add({
                            "username": username,
                            "comment": comment,
                          });
                          comments.clear();
                        }
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
