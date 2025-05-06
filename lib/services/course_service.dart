import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

class CourseService {
  final CollectionReference _coursesCollection =
      FirebaseFirestore.instance.collection('courses');

  final CollectionReference _enrollmentsCollection =
      FirebaseFirestore.instance.collection('enrollments');

  Future<List<CourseModel>> fetchCoursesByCompany(String companyCode) async {
    try {
      final querySnapshot = await _coursesCollection
          .where('companyCode', isEqualTo: companyCode)
          .get();

      return querySnapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  Future<void> createCourse(CourseModel course) async {
    try {
      await _coursesCollection.add(course.toMap());
    } catch (e) {
      print('Error creating course: $e');
    }
  }

  Future<void> enrollUser(String userId, String courseId) async {
    try {
      await _enrollmentsCollection
          .doc('$userId-$courseId')
          .set({'userId': userId, 'courseId': courseId});
    } catch (e) {
      print('Error enrolling user: $e');
    }
  }

  Future<List<String>> fetchEnrolledCourseIds(String userId) async {
    try {
      final querySnapshot = await _enrollmentsCollection
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => doc['courseId'] as String)
          .toList();
    } catch (e) {
      print('Error fetching enrollments: $e');
      return [];
    }
  }

  Future<CourseModel?> fetchById(String courseId) async {
    try {
      final doc = await _coursesCollection.doc(courseId).get();
      if (!doc.exists || doc.data() == null) return null;
      return CourseModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print('Error fetching course by ID: $e');
      return null;
    }
  }

  Future<bool> isUserEnrolled(String userId, String courseId) async {
    try {
      final doc = await _enrollmentsCollection.doc('$userId-$courseId').get();
      return doc.exists;
    } catch (e) {
      print('Error checking enrollment: $e');
      return false;
    }
  }
}
