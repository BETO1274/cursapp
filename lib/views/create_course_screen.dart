import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import 'package:uuid/uuid.dart';


class CreateCourseScreen extends StatefulWidget {
  final String companyCode;
  const CreateCourseScreen({Key? key, required this.companyCode}) : super(key: key);

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _desc = TextEditingController();
  String? _imagePath, _error;
  final _ctrl = CourseController();

  Future<void> _pick() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _imagePath = file.path);
  }
void _save() async {
  if (_desc.text.isEmpty || _imagePath == null) {
    setState(() => _error = 'Faltan campos');
    return;
  }
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("Usuario no autenticado");

    // Generar un ID único
    final courseId = const Uuid().v4();

    // Subir imagen y obtener URL
    final imageUrl = await _ctrl.uploadCourseImage(_imagePath!, widget.companyCode, courseId);

    final course = CourseModel(
      id: courseId,
      title: _desc.text,
      description: _desc.text,
      imageUrl: imageUrl,
      companyCode: widget.companyCode,
      creatorId: userId,
    );

    await _ctrl.createCourse(course);
    Navigator.pop(context);
  } catch (e) {
    setState(() => _error = e.toString());
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Curso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Descripción')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _pick, child: const Text('Seleccionar imagen')),
            if (_imagePath != null) Text(_imagePath!),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Guardar curso')),
          ],
        ),
      ),
    );
  }
}
