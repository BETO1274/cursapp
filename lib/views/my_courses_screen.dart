import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import 'main_scaffold.dart';
import 'course_units_screen.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});
  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  final _ctrl = CourseController();
  List<CourseModel> _courses = [];
  bool _loading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _userId = FirebaseAuth.instance.currentUser?.uid;
    if (_userId != null) {
      _courses = await _ctrl.getEnrolledCourses(_userId!);
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _courses.isEmpty
              ? const Center(child: Text('No estás matriculado en ningún curso'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _courses.length,
                  itemBuilder: (_, i) {
                    final c = _courses[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Image.network(c.imageUrl, width: 60, fit: BoxFit.cover),
                        title: Text(c.title),
                        subtitle: Text(c.description),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseUnitsScreen(
                                courseId: c.id,
                                companyCode: c.companyCode,
                                courseName: c.title,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
