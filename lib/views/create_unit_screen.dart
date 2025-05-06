import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/unit_controller.dart';

class CreateUnitScreen extends StatefulWidget {
  final String courseId;

  const CreateUnitScreen({super.key, required this.courseId});

  @override
  _CreateUnitScreenState createState() => _CreateUnitScreenState();
}

class _CreateUnitScreenState extends State<CreateUnitScreen> {
  final _titleController = TextEditingController();
  File? _pdfFile;
  final _unitController = UnitController();

  // Método para seleccionar archivo PDF
  _pickPdf() async {
    final picker = ImagePicker();
    final result = await picker.pickVideo(source: ImageSource.gallery); // Usa esta línea para cargar el archivo PDF
    if (result != null) {
      setState(() {
        _pdfFile = File(result.path!);
      });
    }
  }

  // Crear la unidad
  _createUnit() async {
    if (_titleController.text.isEmpty || _pdfFile == null) {
      // Mostrar error si los campos están vacíos
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor ingresa un título y selecciona un archivo PDF.')));
      return;
    }

    // Llamar al controlador para crear la unidad
    await _unitController.addUnit(
      courseId: widget.courseId,
      title: _titleController.text,
      pdfPath: _pdfFile!.path,
    );
    Navigator.pop(context); // Volver a la pantalla anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Unidad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título de la unidad'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickPdf,
              child: const Text('Seleccionar archivo PDF'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createUnit,
              child: const Text('Crear Unidad'),
            ),
          ],
        ),
      ),
    );
  }
}
