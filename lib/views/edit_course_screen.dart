import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
import '../services/image_service.dart';

class EditCourseScreen extends StatefulWidget {
  final CourseModel course;

  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  File? _newImage;
  bool _loading = false;

  final _service = CourseService();

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.course.description);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _newImage = File(picked.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    String imageUrl = widget.course.imageUrl;

    if (_newImage != null) {
      imageUrl = await ImageService.uploadCourseImage(
        widget.course.companyCode,
        widget.course.id,
        _newImage!.path,
      );
    }

    final updatedCourse = CourseModel(
      id: widget.course.id,
      companyCode: widget.course.companyCode,
      description: _descriptionController.text.trim(),
      imageUrl: imageUrl,
      creatorId: widget.course.creatorId,
    );

    await _service.update(updatedCourse);

    setState(() => _loading = false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Curso actualizado")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Curso")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_newImage != null)
                      Image.file(_newImage!, height: 200, fit: BoxFit.cover)
                    else if (widget.course.imageUrl.isNotEmpty)
                      Image.network(widget.course.imageUrl, height: 200, fit: BoxFit.cover),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text("Cambiar Imagen"),
                      onPressed: _pickImage,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                      validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text("Guardar Cambios"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
