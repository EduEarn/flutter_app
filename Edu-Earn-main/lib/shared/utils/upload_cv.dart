import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart';

Future<String> uploadCV({required BuildContext context, required File pickedCv}) async {
  try {
    String filename = '${DateTime.now().millisecondsSinceEpoch}${extension(pickedCv.path)}';
    Reference storageReference = FirebaseStorage.instance.ref().child('cvs/$filename');

    await storageReference.putFile(pickedCv);

    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
    debugPrint('Error uploading CV: $e');
    return '';
  }
}
