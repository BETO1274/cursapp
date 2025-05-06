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

      final courseId = const Uuid().v4();
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
      body: Center(  // Centra todo el contenido
        child: SingleChildScrollView(  // Permite desplazar el contenido si es necesario
          padding: const EdgeInsets.all(16),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,  // Permite que el contenido se ajuste a su tamaño
              children: [
                // Descripción con estilo bonito
                TextField(
                  controller: _desc,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Introduce la descripción del curso',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),

                // Botón de seleccionar imagen con fondo blanco y texto negro
                ElevatedButton(
                  onPressed: _pick,
                  child: const Text('Seleccionar imagen', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                if (_imagePath != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _imagePath!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],

                // Mensaje de error
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                ],

                const SizedBox(height: 20),

                // Botón de guardar curso con fondo blanco y texto negro
                ElevatedButton(
                  onPressed: _save,
                  child: const Text('Guardar curso', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
