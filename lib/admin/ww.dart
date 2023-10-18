// ignore_for_file: prefer_const_constructors, camel_case_types, use_key_in_widget_constructors, unnecessary_cast, avoid_unnecessary_containers, sort_child_properties_last, prefer_interpolation_to_compose_strings, unrelated_type_equality_checks, use_build_context_synchronously, unused_element, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class wardens extends StatefulWidget {
  const wardens({Key? key});

  @override
  State<wardens> createState() => _wardensState();
}

class _wardensState extends State<wardens> {
  late List<Map<String, dynamic>> wardens = [];
  late List<Map<String, dynamic>> filteredUsers = [];
  String? email;
  String? userId;
  String? phone;
  int? checkuser;
  String? currentMonthName;
  int? currentYear;
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    userId = user.uid;
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    await fetchUserCheckuser(user.uid);
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .orderBy("username")
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        wardens = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        filterUsers(''); // Apply initial filter to show all users
      });
    }
  }

  void _showEditDialog(String index, String name, double total) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit salary '),
          content: Text('Change payment status for ?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                _updateUI();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Add salary '),
              onPressed: () {
                _addNewBill(index, name);
              },
            ),
            TextButton(
              child: Text('Mark as Paid'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(index)
                    .update({"paid": 1});
                setState(() {});
                _updateUI();
                Navigator.pop(context);
                setState(() {
                  final now = DateTime.now();
                  currentYear = now.year;
                  final currentMonth = now.month;
                  final monthNames = [
                    '', // Index 0 is left empty since months are 1-based
                    'January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November',
                    'December'
                  ];
                  currentMonthName = monthNames[currentMonth];
                  print('Current Month: $currentMonthName');
                });
                await FirebaseFirestore.instance
                    .collection("salary")
                    .doc()
                    .set({
                  "month": currentMonthName,
                  "year": currentYear,
                  "salary": total,
                  "paid": "paid",
                  "name": name,
                  "empId": index,
                });
              },
            ),
            TextButton(
              child: Text('Mark as Unpaid'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(index)
                    .update({"paid": 0});
                setState(() {});
                _updateUI();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _updateUI() {
    setState(() {
      // Rebuild the UI by calling setState
    });
  }

  void _addNewBill(String index, String name) {
    showDialog(
      context: context,
      builder: (context) {
        double amount = 0.0;

        return AlertDialog(
          title: Text('Add New salary '),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name),
              SizedBox(
                height: 3,
              ),
              TextField(
                onChanged: (value) {
                  amount = double.tryParse(value) ?? .0;
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Amount '),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                _updateUI();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Add salary  '),
              onPressed: () async {
                final userDoc = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(index)
                    .get();

                if (mounted) {
                  // Check if the widget is still active
                  if (userDoc.exists) {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(index)
                        .update({"salary": amount});
                    _updateUI();

                    setState(
                        () {}); // Call setState if the widget is still active
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUserCheckuser(String userId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        checkuser = data?["checkuser"];
      });
    }
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, show all users
        filteredUsers = List.from(wardens);
      } else {
        filteredUsers = wardens.where((user) {
          final String name = user['username'].toString().toLowerCase();
          final String email = user['email'].toString().toLowerCase();

          return name.contains(query.toLowerCase()) ||
              email.contains(query.toLowerCase());
        }).toList();
      }

      final int? currentUserCheckuser = checkuser;

      // Customize these conditions to filter based on your needs
      if (currentUserCheckuser == 0) {
        // Display users with checkuser value 0
        filteredUsers =
            filteredUsers.where((user) => user['checkuser'] == 0).toList();
      } else if (currentUserCheckuser == 2) {
        // Display users with checkuser value 2
        filteredUsers =
            filteredUsers.where((user) => user['checkuser'] == 2).toList();
      } else if (currentUserCheckuser == 1) {
        // Display users with checkuser value 1
        filteredUsers =
            filteredUsers.where((user) => user['checkuser'] == 2).toList();
      }
      // Add more conditions as needed.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 80, 140),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Wardens"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: filterUsers,
                decoration: InputDecoration(
                  hintText: 'Search by name or email',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> user = filteredUsers[index];
                  var username = user['username'];
                  email = user['email'];
                  var docid = user['userId'];
                  phone = user["uPhone"];
                  var paid = user["paid"];
                  var salary = user["salary"];
                  var userCheckuser = user["checkuser"] as int;

                  return Card(
                    // Remove the default elevation
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Color.fromARGB(26, 47, 144, 223),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    shadowColor: Color.fromARGB(255, 198, 231, 235)
                        .withOpacity(0.5), // Shadow color
                    elevation: 5, // Elevation (blur radius)

                    child: ListTile(
                      leading: Container(
                        width: 50,
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "  Name:$username",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email: $email"),
                                  Text("Contact: $phone"),
                                  Text("Salary: $salary"),
                                  paid == 0
                                      ? Text("Salary status: Not paid")
                                      : Text("Salary status: paid"),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _showEditDialog(
                                                  docid, username, salary);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                userCheckuser == 0
                                                    ? "User"
                                                    : userCheckuser == 1
                                                        ? "Employee"
                                                        : "Edit salary",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 7, 80, 140),
                                              shape: const StadiumBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            paid == 0
                                                ? "unpaid"
                                                : userCheckuser == 1
                                                    ? "Employee"
                                                    : "paid",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 7, 80, 140),
                                          shape: const StadiumBorder(),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
