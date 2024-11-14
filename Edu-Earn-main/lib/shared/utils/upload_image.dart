import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<String> uploadImageToFirebase(String pickedImage) async {
  try {
    Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
    await storageReference.putFile(File(pickedImage));
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    debugPrint('Error uploading image: $e');
    return '';
  }
}
