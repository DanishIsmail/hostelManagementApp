// ignore_for_file: camel_case_types, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:hostelhub/payment/payment.dart';
import 'package:hostelhub/payment/success.dart';

class paymentType extends StatefulWidget {
  const paymentType({super.key});

  @override
  State<paymentType> createState() => _paymentTypeState();
}

class _paymentTypeState extends State<paymentType> {
  bool isCashOnDeliverySelected = true;
  bool isEasypaisaSelected = false;
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
        title: const Text("Payment method"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Radio(
                value: true,
                groupValue: isCashOnDeliverySelected,
                onChanged: (value) {
                  setState(() {
                    isCashOnDeliverySelected = value as bool;
                    isEasypaisaSelected = !value;
                  });
                },
                activeColor: Color.fromARGB(255, 7, 80, 140),
              ),
              title: Text('By Hand'),
            ),
            ListTile(
              leading: Radio(
                value: true,
                groupValue: isEasypaisaSelected,
                onChanged: (value) {
                  setState(() {
                    isEasypaisaSelected = value as bool;
                    isCashOnDeliverySelected = !value;
                  });
                },
                activeColor: Color.fromARGB(255, 7, 80, 140),
              ),
              title: Text('By Bank'),
            ),
            if (isEasypaisaSelected)
              Text('We are working on it to Ease your assurance'),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text(
                      "proceed",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 7, 80, 140),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    onPressed: () {
                      if (isCashOnDeliverySelected) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Sucess()));
                      } else if (isEasypaisaSelected) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => payment_method()));
                      }
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
