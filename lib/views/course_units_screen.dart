import 'package:flutter/material.dart';
import '../controllers/unit_controller.dart';
import '../models/unit_model.dart';
import '../views/pdf_viewer_screen.dart';

class CourseUnitsScreen extends StatefulWidget {
  final String companyCode;
  final String courseId;
  final String courseName;
  final bool isCreator;

  const CourseUnitsScreen({
    super.key,
    required this.companyCode,
    required this.courseId,
    required this.courseName,
    this.isCreator = false,
    
  });

  @override
  State<CourseUnitsScreen> createState() => _CourseUnitsScreenState();
}

class _CourseUnitsScreenState extends State<CourseUnitsScreen> {
  final UnitController _unitController = UnitController();
  List<UnitModel> _units = [];

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final units = await _unitController.getUnits(widget.companyCode, widget.courseId);
    setState(() {
      _units = units;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unidades: ${widget.courseName}')),
      body: _units.isEmpty
          ? const Center(child: Text('No hay unidades disponibles'))
          : ListView.builder(
              itemCount: _units.length,
              itemBuilder: (context, index) {
                final unit = _units[index];
                return ExpansionTile(
                  title: Text(unit.name),
                  subtitle: Text(unit.description),
                  children: unit.pdfUrls.map((url) {
                    final pdfName = url.split('/').last.split('?').first;
                    return ListTile(
                      leading: const Icon(Icons.picture_as_pdf),
                      title: Text(pdfName),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PdfViewerScreen(pdfUrl: url, pdfName: pdfName),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
