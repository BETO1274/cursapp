import 'package:flutter/material.dart';
import '../models/user.model.dart';
import '../controllers/profile_controller.dart';
import 'main_scaffold.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _name, _position;
  final _ctrl = ProfileController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.user.name);
    _position = TextEditingController(text: widget.user.position);
  }

  void _save() async {
    final updated = widget.user.copyWith(name: _name.text, position: _position.text);
    try {
      await _ctrl.updateProfile(updated);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MainScaffold(child: MyCoursesScreen())),
        (r) => false,
      );
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: _position, decoration: const InputDecoration(labelText: 'Cargo')),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
