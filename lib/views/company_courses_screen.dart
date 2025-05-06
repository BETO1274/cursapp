import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import '../providers/user_provider.dart';
import '../views/main_scaffold.dart';
import 'course_units_screen.dart';
import 'create_course_screen.dart';
import 'create_unit_screen.dart';

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
              builder:
                  (_) => CreateCourseScreen(companyCode: widget.companyCode),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        course.imageUrl != null
                            ? Image.network(
                              course.imageUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                            : const Icon(Icons.book, size: 60),
                        const SizedBox(width: 10),
                        Expanded(child: Text(course.description)),
                        const SizedBox(width: 10),
                        if (isCreator) ...[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => CourseUnitsScreen(
                                        courseId: course.id,
                                        companyCode: course.companyCode,
                                        courseName: course.title,
                                        isCreator: true,
                                      ),
                                ),
                              );
                            },
                            child: const Text('Editar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => CreateUnitScreen(
                                        courseId: course.id,
                                        companyCode: widget.companyCode,
                                      ),
                                ),
                              );
                            },
                            child: const Text('Agregar unidad'),
                          ),
                        ] else
                          ElevatedButton(
                            onPressed: () async {
                              await _courseController.enroll(
                                currentUserId,
                                course.id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Matriculado exitosamente'),
                                ),
                              );
                            },
                            child: const Text('Matricularse'),
                          ),
                      ],
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
