import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/unit_model.dart';

class UnitService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  /// Crea una unidad dentro de courses/{courseId}/units
  Future<void> createUnit({
    required String courseId,
    required String title,
    required String pdfPath,
  }) async {
    final unitId = _uuid.v4();
    // 1) Subir PDF
    final ref = _storage.ref().child('courses/$courseId/units/$unitId.pdf');
    await ref.putFile(File(pdfPath));
    final pdfUrl = await ref.getDownloadURL();
    // 2) Guardar metadata en Firestore
    final unit = UnitModel(
      id: unitId,
      courseId: courseId,
      title: title,
      pdfUrl: pdfUrl,
    );
    await _db
        .collection('courses')
        .doc(courseId)
        .collection('units')
        .doc(unitId)
        .set(unit.toMap());
  }

  /// Trae todas las unidades de un curso
  Future<List<UnitModel>> fetchUnits(String courseId) async {
    final snap = await _db
        .collection('courses')
        .doc(courseId)
        .collection('units')
        .orderBy('title')
        .get();
    return snap.docs.map((d) => UnitModel.fromMap(d.data())).toList();
  }
}
