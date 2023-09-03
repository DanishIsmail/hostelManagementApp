// ignore_for_file: unused_label

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'loader.dart';

void main() async {
  // Ensure that Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp();

  // Continue with the rest of your application setup.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      home:
          Splashscreen(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
