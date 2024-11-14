import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key, required this.user});

  final UserEntity user;

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> updateProfile() async {
    String? imageUrl;
    if (_image != null) {
      // Upload image to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('user_profiles/${DateTime.now()}.png');
      await ref.putFile(_image!);
      imageUrl = await ref.getDownloadURL();
    }

    // Get the current user's UID
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not authenticated')),
      );
      return;
    }

    // Query Firestore to get the document ID for the current user
    final QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (userQuery.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User document not found')),
      );
      return;
    }

    final String docId = userQuery.docs.first.id;

    // Update user data in Firestore
    await FirebaseFirestore.instance.collection('users').doc(docId).update({
      if (imageUrl != null) 'image': imageUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: getImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : (widget.user.image != null ? NetworkImage(widget.user.image!) : null)
                  as ImageProvider?,
                  child: _image == null && widget.user.image == null
                      ? const Icon(Icons.add_a_photo, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProfile,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}