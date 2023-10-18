// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_constructors, unused_local_variable, unused_element, use_build_context_synchronously, avoid_print, avoid_unnecessary_containers, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class warden extends StatefulWidget {
  const warden({Key? key}) : super(key: key);

  @override
  _BillsUserState createState() => _BillsUserState();
}

class _BillsUserState extends State<warden> {
  String? currentMonthName;
  int? currentYear;

  @override
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("checkuser", isEqualTo: 2)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
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
                'No users yet.',
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
                var paid = data?["paid"];
                var username = data?['username'];
                var email = data?['email'];
                var docid = data?['userId'];
                var phone = data?["uPhone"];
                var salary = data?["salary"];
                var userCheckuser = data?["checkuser"] as int;
                // var status = data?["status"];
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
                                                document.id, username, salary);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                            backgroundColor:
                                                Color.fromARGB(255, 7, 80, 140),
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
                                          style: TextStyle(color: Colors.white),
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

                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Color(0xff392850),
                //       width: 2,
                //     ),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   margin: EdgeInsets.all(8),
                //   padding: EdgeInsets.all(8),
                //   child: Row(
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             name,
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //           SizedBox(height: 5),
                //           Text(
                //             paid == 0 ? "Not paid" : "Paid",
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //         ],
                //       ),
                //       IconButton(
                //         icon: Icon(
                //             Icons.edit), // Use Icon widget to specify the icon
                //         onPressed: () {
                //           _showEditDialog(document.id);
                //         },
                //       )
                //     ],
                //   ),
                // );
              });
        },
      ),
      // body: bills.isEmpty
      // ? Center(
      //     child: Text('No bills yet'),
      //   )
      // : ListView.builder(
      //     itemCount: bills.length,
      //     itemBuilder: (context, index) {
      //       return Card(
      //         margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //         color: bills[index].isPaid
      //             ? Colors.white
      //             : Color.fromARGB(255, 211, 180, 252),
      //         child: ListTile(
      //           title: Text(bills[index].userName),
      //           subtitle: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text('${bills[index].amount.toStringAsFixed(2)} '),
      //               Text(bills[index].isPaid ? 'Paid' : 'Not Paid'),
      //             ],
      //           ),
      //           trailing: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               IconButton(
      //                 icon: Icon(Icons.edit),
      //                 onPressed: () {
      //                   _showEditDialog(index);
      //                 },
      //               ),
      //               IconButton(
      //                 icon: Icon(Icons.delete),
      //                 onPressed: () {
      //                   _deleteBill(index);
      //                 },
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color.fromARGB(255, 211, 180, 252),
      //   onPressed: _addNewBill,
      //   child: Icon(Icons.add),
      // ),
    );
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
}


//herrergghjghjkghjhj