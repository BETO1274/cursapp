import 'package:flutter/material.dart';
import '../controllers/unit_controller.dart';
import '../models/unit_model.dart';
import 'unit_viewer_screen.dart';
import 'create_unit_screen.dart';
import 'main_scaffold.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  const CourseDetailScreen({Key? key, required this.courseId})
    : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final _ctrl = UnitController();
  List<UnitModel> _units = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    _units = await _ctrl.loadUnits(widget.courseId);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      child:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _units.length,
                      itemBuilder: (_, i) {
                        final u = _units[i];
                        return ListTile(
                          title: Text(u.title),
                          trailing: IconButton(
                            icon: const Icon(Icons.picture_as_pdf),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => UnitViewerScreen(pdfUrl: u.pdfUrl),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar Unidad'),
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => CreateUnitScreen(
                                    courseId: widget.courseId,
                                  ),
                            ),
                          ).then((_) => _loadUnits()),
                    ),
                  ),
                ],
              ),
    );
  }
}
