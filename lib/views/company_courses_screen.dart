import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import '../providers/user_provider.dart';
import '../views/main_scaffold.dart';
import 'course_units_screen.dart';
import 'create_course_screen.dart'; // Asegúrate de importar la pantalla de creación

class CompanyCoursesScreen extends StatefulWidget {
  final String companyCode;
  const CompanyCoursesScreen({super.key, required this.companyCode});

  @override
  State<CompanyCoursesScreen> createState() => _CompanyCoursesScreenState();
}

class _CompanyCoursesScreenState extends State<CompanyCoursesScreen> {
  final CourseController _courseController = CourseController();
  List<CourseModel> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _courseController.getCourses(widget.companyCode);
    setState(() => _courses = courses);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider.of<UserProvider>(context).user.uid;

    return MainScaffold(
      currentIndex: 1,
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateCourseScreen(companyCode: widget.companyCode),
      ),
    );
  },
  child: const Icon(Icons.add),
  tooltip: 'Crear curso',
),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _courses.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final course = _courses[index];
                final isCreator = course.creatorId == currentUserId;

                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: course.imageUrl != null
                        ? Image.network(course.imageUrl!, width: 60, height: 60, fit: BoxFit.cover)
                        : const Icon(Icons.book),
                    title: Text(course.description),
                    trailing: isCreator
                        ? ElevatedButton(
                            child: const Text('Editar'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CourseUnitsScreen(course: course, isCreator: true),
                                ),
                              );
                            },
                          )
                        : ElevatedButton(
                            child: const Text('Matricularse'),
                            onPressed: () async {
                              await _courseController.enroll(currentUserId, course.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Matriculado exitosamente')),
                              );
                            },
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
