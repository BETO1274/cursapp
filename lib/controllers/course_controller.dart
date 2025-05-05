import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
import '../services/image_service.dart'; 

class CourseController {
  final CourseService _service = CourseService();

  Future<List<CourseModel>> getCourses(String companyCode) async {
    return await _service.fetchCoursesByCompany(companyCode);
  }

  Future<void> createCourse(CourseModel course) async {
    await _service.createCourse(course);
  }

  Future<void> enroll(String userId, String courseId) async {
    await _service.enrollUser(userId, courseId);
  }

  Future<bool> isEnrolled(String userId, String courseId) async {
    return await _service.isUserEnrolled(userId, courseId);
  }

  Future<List<CourseModel>> getEnrolledCourses(String userId) async {
    final enrolledIds = await _service.fetchEnrolledCourseIds(userId);
    final futures = enrolledIds.map((id) => _service.fetchById(id)).toList();
    final courses = await Future.wait(futures);
    return courses.whereType<CourseModel>().toList();
  }

  Future<CourseModel?> getById(String id) async {
    return await _service.fetchById(id);
  }

  Future<String> uploadCourseImage(String imagePath, String companyCode, String courseId) async {
  return await ImageService.uploadCourseImage(companyCode, courseId, imagePath);
}


}
