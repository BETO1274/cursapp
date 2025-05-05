import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../models/user.model.dart';
import '../providers/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _position = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = AuthController();
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
              TextField(
                  controller: _pass,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true),
              TextField(controller: _code, decoration: const InputDecoration(labelText: 'Código empresa')),
              TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: _position, decoration: const InputDecoration(labelText: 'Cargo')),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  var user = await auth.register(
                    email: _email.text,
                    password: _pass.text,
                    name: _name.text,
                    position: _position.text,
                    companyCode: _code.text,
                  );
                  if (user != null) {
                    Provider.of<UserProvider>(context, listen: false).setUser(user);
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    setState(() => _error = 'No se pudo registrar');
                  }
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
