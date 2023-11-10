// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, deprecated_member_use, prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final picker = ImagePicker();
  PickedFile? _image;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    QuerySnapshot imageSnapshot =
        await FirebaseFirestore.instance.collection('images').get();

    setState(() {
      _imageUrls = imageSnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)["url"] as String)
          .toList();
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _saveImage() async {
    if (_image == null) {
      return;
    }

    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
    UploadTask uploadTask = storageReference.putFile(File(_image!.path));
    await uploadTask.whenComplete(() async {
      String imageUrl = await storageReference.getDownloadURL();

      await FirebaseFirestore.instance.collection('images').add({
        'url': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _image = null;
      });

      _fetchImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Image.file(
                File(_image!.path),
                width: 200,
                height: 200,
              )
            else
              Icon(
                Icons.image,
                size: 100,
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an image from gallery'),
            ),
            ElevatedButton(
              onPressed: _saveImage,
              child: Text('Save to Firebase'),
            ),
            SizedBox(height: 20),
            Text('Images from Firestore:'),
            Column(
              children: _imageUrls.map((imageUrl) {
                return Image.network(
                  imageUrl,
                  width: 200,
                  height: 200,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: UploadImageScreen()));
}
