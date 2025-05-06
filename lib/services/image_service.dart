// En image_service.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  static Future<String> uploadCourseImage(
    String companyCode,
    String courseId,
    String imagePath,
  ) async {
    final file = File(imagePath);
    final imageId = const Uuid().v4(); 
    final ref = FirebaseStorage.instance.ref().child('courses/$companyCode/$courseId/$imageId.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL(); 
  }
}
