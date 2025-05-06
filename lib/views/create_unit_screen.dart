import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/unit_controller.dart';
import '../models/unit_model.dart';
import '../providers/user_provider.dart';

class CreateUnitScreen extends StatefulWidget {
  final String courseId;
  final String companyCode;

  const CreateUnitScreen({
    super.key,
    required this.courseId,
    required this.companyCode,
  });

  @override
  State<CreateUnitScreen> createState() => _CreateUnitScreenState();
}

class _CreateUnitScreenState extends State<CreateUnitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final UnitController _unitController = UnitController();
  List<File> _pdfFiles = [];
  List<UnitModel> _existingUnits = [];

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final units = await _unitController.getUnits(widget.companyCode, widget.courseId);
    setState(() {
      _existingUnits = units;
    });
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _pdfFiles.addAll(result.paths.map((path) => File(path!)).toList());
      });
    }
  }

  Future<void> _createUnit() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre y descripción son obligatorios')),
      );
      return;
    }

    final unit = UnitModel(
      id: '',
      name: name,
      description: description,
      pdfUrls: [],
    );

    final unitId = await _unitController.addUnit(widget.companyCode, widget.courseId, unit);

    List<String> pdfUrls = [];
    for (File pdf in _pdfFiles) {
      final url = await _unitController.uploadPdf(
        widget.companyCode,
        widget.courseId,
        unitId,
        pdf,
      );
      pdfUrls.add(url);
    }

    if (pdfUrls.isNotEmpty) {
      await _unitController.updatePdfUrls(
        widget.companyCode,
        widget.courseId,
        unitId,
        pdfUrls,
      );
    }

    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _pdfFiles.clear();
    });

    _loadUnits();
  }

  void _removePdf(int index) {
    setState(() {
      _pdfFiles.removeAt(index);
    });
  }

  Widget _buildPdfPreview() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _pdfFiles.length,
      itemBuilder: (context, index) {
        final fileName = _pdfFiles[index].path.split('/').last;
        return ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: Text(fileName),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removePdf(index),
          ),
        );
      },
    );
  }

  Widget _buildExistingUnits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Unidades creadas:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ..._existingUnits.map((unit) => Card(
              child: ExpansionTile(
                title: Text(unit.name),
                subtitle: Text(unit.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('¿Eliminar unidad?'),
                        content: Text('¿Deseas eliminar la unidad "${unit.name}" y todos sus PDFs?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await _unitController.deleteUnit(
                        widget.companyCode,
                        widget.courseId,
                        unit,
                      );
                      _loadUnits();
                    }
                  },
                ),
                children: [
                  ...unit.pdfUrls.map((pdfUrl) => ListTile(
                        leading: const Icon(Icons.picture_as_pdf),
                        title: Text(pdfUrl.split('/').last),
                        subtitle: Text(pdfUrl),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _unitController.removePdfUrl(
                              widget.companyCode,
                              widget.courseId,
                              unit.id,
                              pdfUrl,
                            );
                            _loadUnits();
                          },
                        ),
                      )),
                  TextButton.icon(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (result != null && result.files.single.path != null) {
                        final file = File(result.files.single.path!);
                        final url = await _unitController.uploadPdf(
                          widget.companyCode,
                          widget.courseId,
                          unit.id,
                          file,
                        );
                        await _unitController.updatePdfUrls(
                          widget.companyCode,
                          widget.courseId,
                          unit.id,
                          [url],
                        );
                        _loadUnits();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Agregar PDF"),
                  )
                ],
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Unidad')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre de la unidad'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Seleccionar PDFs'),
            ),
            _buildPdfPreview(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createUnit,
              child: const Text('Guardar Unidad'),
            ),
            const Divider(height: 30),
            _buildExistingUnits(),
          ],
        ),
      ),
    );
  }
}
