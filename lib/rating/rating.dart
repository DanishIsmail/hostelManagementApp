// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_null_comparison, sized_box_for_whitespace, unnecessary_cast, prefer_const_constructors_in_immutables, unused_local_variable, unused_import, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostelhub/Userdetails/userdetails_controller.dart';
import 'package:hostelhub/login/singup/login_controller.dart';
import 'package:hostelhub/services/hostel_details_controller.dart';
import 'package:rating_dialog/rating_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RatingApp(),
    );
  }
}

class RatingApp extends StatefulWidget {
  @override
  _RatingAppState createState() => _RatingAppState();
}

class _RatingAppState extends State<RatingApp> {
  double userRating = 0.0;
  String userFeedback = "";
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _updateAverageRating();
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
        title: Text('Rating and Review hostel'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Average Rating:',
                    style: TextStyle(fontSize: 20),
                  ),
                  buildAverageRatingStars(averageRating), // Show stars here
                ],
              ),
            ),
            _buildFeedbackList(),
            Center(
              child: Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser != null) {
                      _showRatingDialog();
                    } else {
                      _showLoginDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 7, 80, 140),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 30),
                  ),
                  child: Text('Rate and Give Feedback'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showRatingDialog() async {
    final _dialog = CustomRatingDialog(
      icon: Icon(Icons.star),
      submitButtonText: 'Submit',
      title: Text('Rate this hostel'),
      message: Text('Give us your rating and feedback to improve our app.'),
      onCancelled: (response) => print('cancelled'),
      onSubmitted: (response) async {
        if (response.rating != null && response.comment.isNotEmpty) {
          print('rating: ${response.rating}, comment: ${response.comment}');
          await _saveRatingToFirebase(
            response.rating,
            response.comment,
            FirebaseAuth.instance.currentUser!.uid,
          );
          setState(() {
            userRating = response.rating;
            userFeedback = response.comment;
          });
        } else {
          // Show a Flutter toast if the user didn't provide both rating and feedback.
          Fluttertoast.showToast(
            backgroundColor: Color.fromARGB(255, 7, 80, 140),
            msg: 'Please select stars and provide feedback',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      },
    );
    await showDialog(
      context: context,
      builder: (context) {
        return _dialog;
      },
    );
  }

  Future<void> _saveRatingToFirebase(
    double rating,
    String comment,
    String userId,
  ) async {
    if (rating != null && comment.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection("${HostelController().hostelName}" + 'ratings')
            .add({
          'rating': rating,
          'feedback': comment,
          'username': userController().username,
          'userId': userId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('Rating and feedback saved to Firebase');
        _updateAverageRating();
      } catch (e) {
        print('Error saving rating and feedback: $e');
      }
    } else {
      // Optionally, you can show a Flutter toast or handle this case as needed.
      print('Both rating and feedback are required to save in the database.');
    }
  }

  Future<void> _showLoginDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please log in to rate'),
            content: Text('You need to log in to rate and provide feedback.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  // Future<void> _saveRatingToFirebase(
  //   double rating,
  //   String comment,
  //   String userId,
  // ) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("${HostelController().hostelName}" + 'ratings')
  //         .add({
  //       'rating': rating,
  //       'feedback': comment,
  //       'username': userController().username,
  //       'userId': userId,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //     print('Rating and feedback saved to Firebase');
  //     _updateAverageRating();
  //   } catch (e) {
  //     print('Error saving rating and feedback: $e');
  //   }
  // }

  Future<void> _updateAverageRating() async {
    final ratings = await FirebaseFirestore.instance
        .collection("${HostelController().hostelName}" + 'ratings')
        .get();
    double totalRating = 0.0;
    int ratingCount = 0;

    for (final rating in ratings.docs) {
      final ratingData = rating.data() as Map<String, dynamic>;
      final userRating = ratingData['rating'] as double;
      totalRating += userRating;
      ratingCount++;
    }

    if (ratingCount > 0) {
      setState(() {
        averageRating = totalRating / ratingCount;
      });
    }
  }

  Widget _buildFeedbackList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("${HostelController().hostelName}" + 'ratings')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final ratings = snapshot.data?.docs;
        List<Widget> ratingWidgets = [];
        for (var rating in ratings!) {
          final ratingData = rating.data() as Map<String, dynamic>;
          final userRating = ratingData['rating'] as double;
          final userFeedback = ratingData['feedback'] as String;
          final username = ratingData['username'];
          ratingWidgets.add(
            ListTile(
              title: Text('$username'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rating: $userRating'),
                  Text('Feedback: $userFeedback'),
                ],
              ),
            ),
          );
        }
        return Column(children: ratingWidgets);
      },
    );
  }
}

class CustomRatingDialog extends RatingDialog {
  final Icon icon;

  CustomRatingDialog({
    required this.icon,
    required String submitButtonText,
    required Text title,
    required Text message,
    required void Function(RatingDialogResponse response) onCancelled,
    required void Function(RatingDialogResponse response) onSubmitted,
  }) : super(
          submitButtonText: submitButtonText,
          title: title,
          message: message,
          onCancelled: onCancelled,
          onSubmitted: onSubmitted,
        );
}

Widget buildAverageRatingStars(double averageRating) {
  // Create a list of Icon widgets for the stars.
  List<Icon> starIcons = [];
  for (int i = 1; i <= 5; i++) {
    starIcons.add(
      Icon(
        Icons.star,
        color: i <= averageRating ? Colors.yellow : Colors.grey,
      ),
    );
  }

  // Return the row of star icons.
  return Row(
    children: starIcons,
  );
}
