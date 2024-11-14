import 'dart:io';
import 'package:file_picker/file_picker.dart';

Future<File?> uploadFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  } catch (err) {
    return null;
  }
}
