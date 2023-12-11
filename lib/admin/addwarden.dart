// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelhub/admin/wardens.dart';

class Addwaden extends StatefulWidget {
  const Addwaden({Key? key}) : super(key: key);

  @override
  State<Addwaden> createState() => _AddwadenState();
}

class _AddwadenState extends State<Addwaden> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController uPhonenoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  bool isPasswordVisible = false; // Track password visibility
  bool isCPasswordVisible = false;
  int? indexx;
  int selectedFuelStation = 0;
  String? selectedhostelname = "00";
  // Track confirm password visibility

  void _createAccount() async {
    var username = usernameController.text.trim();
    var uemail = emailController.text.trim();
    var upassword = passwordController.text.trim();
    var uphone = uPhonenoController.text.trim();
    var ucpassword = cpasswordController.text.trim();

    if (username.isEmpty ||
        uemail.isEmpty ||
        upassword.isEmpty ||
        selectedhostelname == "00" ||
        uphone.isEmpty ||
        ucpassword.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill in all fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 7, 80, 140),
        textColor: Colors.white,
      );
      return;
    }

    if (!RegExp(
            r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$')
        .hasMatch(uemail)) {
      Fluttertoast.showToast(
        msg: "Please enter a valid email address",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 7, 80, 140),
        textColor: Colors.white,
      );
      return;
    }

    if (upassword != ucpassword) {
      Fluttertoast.showToast(
        msg: "Passwords do not match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 7, 80, 140),
        textColor: Colors.white,
      );
      return;
    }
    if (upassword.length < 8 ||
        !upassword.contains(RegExp(r'[A-Z]')) ||
        !upassword.contains(RegExp(r'[0-9]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Password must be at least 8 characters long and contain at least one capital letter and one number'),
        ),
      );
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: uemail,
        password: upassword,
      );

      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          "username": username,
          "email": uemail,
          "password": upassword,
          "createdId": DateTime.now(),
          "uPhone": uphone,
          "profileImage": " ",
          'active': 0,
          "userId": user.uid,
          "hostelName": selectedhostelname,
          "checkuser": 2,
          'paid': 0,
          "salary": 0,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => warden()),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error creating account: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 7, 80, 140),
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(),
                _inputFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: const [
        SizedBox(
          height: 60,
        ),
        Text(
          "Create Account",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter details to get started"),
      ],
    );
  }

  Widget _inputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 40,
        ),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "Username",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Email id",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: uPhonenoController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Phone no",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.phone_android),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock_outline_sharp),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordVisible =
                      !isPasswordVisible; // Toggle password visibility
                });
              },
              child: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
          obscureText:
              !isPasswordVisible, // Set obscureText based on visibility state
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: cpasswordController,
          decoration: InputDecoration(
            hintText: "Retype Password",
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock_outline_sharp),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isCPasswordVisible =
                      !isCPasswordVisible; // Toggle confirm password visibility
                });
              },
              child: Icon(
                isCPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
          obscureText:
              !isCPasswordVisible, // Set obscureText based on visibility state
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 120,
          // ignore: avoid_unnecessary_containers
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('hostel').snapshots(),
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
                      'No hostel yet.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: documents.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(); // Add a divider between items.
                  },
                  itemBuilder: (BuildContext context, int index) {
                    QueryDocumentSnapshot document = documents[index];
                    Map<String, dynamic>? data =
                        document.data() as Map<String, dynamic>?;
                    var name = data?['hostelName'];
                    var address = data?['hostelLocation'];
                    // Wrap the Container representing each fuel station with GestureDetector
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          indexx = index;
                          selectedhostelname = name;
                          print("index$index");
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: indexx == index
                                ? Color.fromARGB(255, 7, 80, 140)
                                : Colors.grey,
                            width: 2,
                          ),
                          color: Color(0xffF6F6F6),
                        ),
                        child: Card(
                          elevation: 2,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: Icon(Icons.hotel_sharp),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              address,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: _createAccount,
          child: const Text(
            "Make warden",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 7, 80, 140),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}
