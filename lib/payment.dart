// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print, unused_local_variable, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
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
        title: const Text("Total Funds"),
        backgroundColor: const Color.fromARGB(255, 7, 63, 108),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('payment')
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
                        'NO payments.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
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
                          child: Text("no payment yet"),
                        );
                      }

                      String documentId = document.id;
                      int payment = data['payment'];
                      // var userName = data['username'];

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(26, 47, 144, 223),
                            borderRadius: BorderRadius.circular(
                                8), // You can adjust the radius as needed
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 198, 231, 235)
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 5, // Spread radius
                                blurRadius: 7, // Blur radius
                                offset: Offset(
                                    0, 3), // Offset in the x and y directions
                              ),
                            ],
                          ),
                          width: 300,
                          child: ListTile(
                            title: Text("Month:${documentId}"),
                            subtitle: Text("Total funds:$payment"),
                            // title: Text(userName),
                            // subtitle: Text(userComment),
                          ),
                        ),
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
