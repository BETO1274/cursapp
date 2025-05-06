import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import '../providers/user_provider.dart';
import '../views/main_scaffold.dart';
import 'course_units_screen.dart';
import 'create_course_screen.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _courses.isEmpty
            ? const Center(child: Text('No hay cursos disponibles aún'))
            : GridView.builder(
                itemCount: _courses.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.70,
                ),
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  final isCreator = course.creatorId == currentUserId;

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseUnitsScreen(
                              course: course,
                              isCreator: isCreator,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: course.imageUrl != null && course.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      course.imageUrl!,
                                      width: double.infinity,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.book, size: 50),
                                    ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.description,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ID: ${course.id}',
                                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isCreator ? Colors.indigo : Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 8), // reducido
                                        minimumSize: const Size(0, 36), // altura mínima menor
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (isCreator) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CourseUnitsScreen(
                                                course: course,
                                                isCreator: true,
                                              ),
                                            ),
                                          );
                                        } else {
                                          await _courseController.enroll(currentUserId, course.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Matriculado exitosamente')),
                                          );
                                        }
                                      },
                                      child: Text(
                                        isCreator ? 'Editar' : 'Matricularse',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
