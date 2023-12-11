// ignore_for_file: camel_case_types, library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously, prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers, curly_braces_in_flow_control_structures, avoid_print, sized_box_for_whitespace, unused_import, prefer_final_fields

import 'dart:async';
import 'dart:io';
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

  // Future<void> _sendPayment(userId) async {
  //   setState(() {
  //     _isLoading = false;
  //   });

  //   const url = 'https://www.hblibank.com.pk/Login';
  //   try {
  //     if (await canLaunch(url)) {
  //       // Check if the URL is not an IPv6 address
  //       final Uri uri = Uri.parse(url);
  //       if (uri.host != null && !uri.host!.contains(':')) {
  //         await launch(url);
  //       } else {
  //         throw 'Invalid URL format: $url';
  //       }
  //     } else {
  //       throw 'Could not launch $url';
  //     }
  //   } catch (e) {
  //     print('Error launching URL: $e');
  //   }
  // }

  @override
  void initState() {
    print("userpayment().rent${userpayment().rent}");
    super.initState();
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
                      // ignore: unrelated_type_equality_checks
                      if (userpayment().rent == inputText) {
                        if (!_isLoading) {
                          const link = "https://www.hblibank.com.pk/Login";
                          launchUrl(Uri.parse(link),
                              mode: LaunchMode.inAppWebView);
                          // _sendPayment(userpayment().uid);
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Enter Correct price",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 7, 80, 140),
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
                        backgroundColor: Color.fromARGB(255, 7, 80, 140),
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
