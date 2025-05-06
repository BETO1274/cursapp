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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _courseController.getCourses(widget.companyCode);
    setState(() {
      _courses = courses;
      _isLoading = false;
    });
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _courses.isEmpty
                ? const Center(child: Text('No hay cursos disponibles aún'))
                : GridView.builder(
                    itemCount: _courses.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.70, // más alto para evitar overflow
                    ),
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      final isCreator = course.creatorId == currentUserId;

                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: course.imageUrl.isNotEmpty
                                    ? Image.network(
                                        course.imageUrl,
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
                              const SizedBox(height: 6),
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
                              const SizedBox(height: 2),
                              Text(
                                'ID: ${course.id}',
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              const Spacer(),
                              if (isCreator) ...[
                                _buildButton(
                                  label: 'Visualizar',
                                  color: const Color.fromARGB(255, 231, 231, 231),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CourseUnitsScreen(
                                          courseId: course.id,
                                          companyCode: course.companyCode,
                                          courseName: course.title,
                                          isCreator: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 4),
                                _buildButton(
                                  label: 'Agregar unidad',
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CreateUnitScreen(
                                          courseId: course.id,
                                          companyCode: widget.companyCode,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ] else
                                _buildButton(
                                  label: 'Matricularse',
                                  color: Colors.green,
                                  onPressed: () async {
                                    await _courseController.enroll(currentUserId, course.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Matriculado exitosamente')),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 28, // más compacto para evitar overflow
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 11)),
      ),
    );
  }
}
