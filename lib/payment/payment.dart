// ignore_for_file: camel_case_types, library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously, prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers, curly_braces_in_flow_control_structures, avoid_print, sized_box_for_whitespace

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelhub/payment/paymnet_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../userdashboard/user_dashbord.dart';

class payment_method extends StatefulWidget {
  const payment_method({Key? key}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<payment_method> {
  bool _isLoading = false;
  int? input;
  TextEditingController paymentController = TextEditingController();

  Future<void> _sendPayment(userId) async {
    try {
      // Update payment status to 1
      FirebaseFirestore.instance
          .collection("usersBookedDetails")
          .doc(userId)
          .update({"payment": 1}).then((_) {
        print("Payment status updated to 1 for userId: $userId");

        // Schedule to reset payment status after 30 days
        Timer(Duration(days: 30), () {
          FirebaseFirestore.instance
              .collection("usersBookedDetails")
              .doc(userId)
              .update({"payment": 0}).then((_) {
            print(
                "Payment status reset to 0 for userId: $userId after 30 days");
          }).catchError((error) {
            print("Error resetting payment status: $error");
          });
        });
      }).catchError((error) {
        print("Error updating payment status: $error");
      });
    } catch (e) {
      print("Exception while updating payment status: $e");
    }

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    const url = 'https://www.hblibank.com.pk/Login';
    if (await canLaunch(url)) {
      await launch(url);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => userDashboard()),
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Payment Method'),
          backgroundColor: Color.fromARGB(255, 7, 80, 140),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialPad(),
            SizedBox(height: 16),
            TextField(
              controller: paymentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter amount',
              ),
            ),
            SizedBox(height: 16),
            BankAccountDisplay(),
            SizedBox(height: 16),
            Center(
              child: Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    String inputText =
                        paymentController.text; // Get the input as a string
                    input =
                        int.tryParse(inputText); // Try to parse it to an int

                    if (input != null) {
                      if (userpayment().rent == input &&
                          (userpayment().payment == 0)) {
                        if (!_isLoading) {
                          _sendPayment(userpayment().uid);
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Enter Correct price",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xff392850),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Invalid input. Please enter a valid number.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color(0xff392850),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 7, 80, 140),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Send',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Implement your dial pad UI here
      child: Text('Dial Pad'),
    );
  }
}

class AmountInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller: ,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter amount',
      ),
    );
  }
}

class BankAccountDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Implement your bank account display UI here
      child: Text('Bank Account:11362778929012'),
    );
  }
}
