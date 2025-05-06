import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/unit_model.dart';

class UnitController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> addUnit(String companyCode, String courseId, UnitModel unit) async {
    final docRef = await _firestore
        .collection('companies')
        .doc(companyCode)
        .collection('courses')
        .doc(courseId)
        .collection('units')
        .add(unit.toMap());

    return docRef.id;
  }

  Future<String> uploadPdf(String companyCode, String courseId, String unitId, File file) async {
    final storageRef = _storage
        .ref()
        .child('courses/$companyCode/$courseId/$unitId/${DateTime.now().millisecondsSinceEpoch}.pdf');

    final uploadTask = await storageRef.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> updatePdfUrls(String companyCode, String courseId, String unitId, List<String> pdfUrls) async {
    await _firestore
        .collection('companies')
        .doc(companyCode)
        .collection('courses')
        .doc(courseId)
        .collection('units')
        .doc(unitId)
        .update({'pdfUrls': FieldValue.arrayUnion(pdfUrls)});
  }

Future<void> removePdfUrl(String companyCode, String courseId, String unitId, String pdfUrl) async {
  await _firestore
      .collection('companies')
      .doc(companyCode)
      .collection('courses')
      .doc(courseId)
      .collection('units')
      .doc(unitId)
      .update({
        'pdfUrls': FieldValue.arrayRemove([pdfUrl])
      });


  final ref = _storage.refFromURL(pdfUrl);
  await ref.delete();
}

Future<void> deleteUnit(String companyCode, String courseId, UnitModel unit) async {
  for (String url in unit.pdfUrls) {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    // ignore: empty_catches
    } catch (e) {}
  }

  await _firestore
      .collection('companies')
      .doc(companyCode)
      .collection('courses')
      .doc(courseId)
      .collection('units')
      .doc(unit.id)
      .delete();
}


  Future<List<UnitModel>> getUnits(String companyCode, String courseId) async {
    final snapshot = await _firestore
        .collection('companies')
        .doc(companyCode)
        .collection('courses')
        .doc(courseId)
        .collection('units')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return UnitModel.fromMap(doc.id, data);
    }).toList();
  }
}
