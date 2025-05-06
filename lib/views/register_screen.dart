import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../providers/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _position = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;
  bool _loading = false;
  bool _isPressed = false;
  double _opacity = 0.0;

  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Iniciar la animación al montar
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
      });
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _code.dispose();
    _name.dispose();
    _position.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthController();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Center(
        child: SingleChildScrollView(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                Text(
                  'CursApp', // Nombre de la aplicación
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                Card(
                  elevation: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Crear cuenta',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'El correo es obligatorio'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _pass,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: Icon(Icons.lock_outline),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'La contraseña es obligatoria'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _code,
                            decoration: const InputDecoration(
                              labelText: 'Código de empresa',
                              prefixIcon: Icon(Icons.business_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'El código de empresa es obligatorio'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _name,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'El nombre es obligatorio'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _position,
                            decoration: const InputDecoration(
                              labelText: 'Cargo',
                              prefixIcon: Icon(Icons.work_outline),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'El cargo es obligatorio'
                                    : null,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                          const SizedBox(height: 20),
                          _loading
                              ? const CircularProgressIndicator()
                              : GestureDetector(
                                  onTapDown: (_) =>
                                      setState(() => _isPressed = true),
                                  onTapUp: (_) =>
                                      setState(() => _isPressed = false),
                                  onTapCancel: () =>
                                      setState(() => _isPressed = false),
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _error = null;
                                        _loading = true;
                                      });

                                      var user = await auth.register(
                                        email: _email.text.trim(),
                                        password: _pass.text.trim(),
                                        name: _name.text.trim(),
                                        position: _position.text.trim(),
                                        companyCode: _code.text.trim(),
                                      );

                                      if (user != null) {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .setUser(user);
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                      } else {
                                        setState(() =>
                                            _error = 'No se pudo registrar');
                                      }

                                      setState(() => _loading = false);
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 120),
                                    curve: Curves.easeInOut,
                                    transform: _isPressed
                                        ? Matrix4.translationValues(0, 2, 0)
                                        : Matrix4.identity(),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: _isPressed
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.15),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    width: double.infinity,
                                    child: const Center(
                                      child: Text(
                                        'Registrar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/login'),
                            child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                          ),
                        ],
                      ),
                    ),
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
