import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentService {
  final _db = FirebaseFirestore.instance;

  /// Matricula al usuario en el curso
  Future<void> enroll({
    required String userId,
    required String courseId,
  }) {
    // Guardamos dentro de users/{userId}/enrollments/{courseId}
    return _db
      .collection('users')
      .doc(userId)
      .collection('enrollments')
      .doc(courseId)
      .set({
        'courseId': courseId,
        'enrolledAt': FieldValue.serverTimestamp(),
      });
  }

  /// Opcional: obtiene lista de courseId en que el usuario está matriculado
  Future<List<String>> getUserEnrollments(String userId) async {
    final snap = await _db
      .collection('users')
      .doc(userId)
      .collection('enrollments')
      .get();
    return snap.docs.map((d) => d.id).toList();
  }
}
