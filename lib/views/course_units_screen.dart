import 'package:flutter/material.dart';
import '../models/course_model.dart';

class CourseUnitsScreen extends StatelessWidget {
  final CourseModel course;
  final bool isCreator;

  const CourseUnitsScreen({
    Key? key,
    required this.course,
    required this.isCreator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.description),
      ),
      body: Center(
        child: Text('Unidades del curso: ${course.description}'),
      ),
      floatingActionButton: isCreator
          ? FloatingActionButton(
              onPressed: () {
                // Navegar a crear unidad
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}