// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

SingUPUser(String username, String uemail, String upassword) async {
  User? userid = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(userid as String?)
      .set({
    "username": username,
    "email": uemail,
    "password": upassword,
    "createdId": DateTime.now(),
    "userId": userid,
  });
}
