import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/unit_model.dart';

class UnitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addUnit(String courseId, UnitModel unit) async {
    final ref = _firestore.collection('courses').doc(courseId).collection('units').doc(unit.id);
    await ref.set(unit.toMap());
  }

  Future<List<UnitModel>> getUnits(String courseId) async {
    final snapshot = await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('units')
        .get();

    return snapshot.docs
        .map((doc) => UnitModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<String> uploadPdf(String companyCode, String courseId, String unitId, File pdfFile) async {
    final fileName = const Uuid().v4();
    final ref = _storage
        .ref()
        .child('courses/$companyCode/$courseId/$unitId/$fileName.pdf');

    await ref.putFile(pdfFile);
    return await ref.getDownloadURL();
  }
}
