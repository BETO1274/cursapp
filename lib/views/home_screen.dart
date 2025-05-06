import 'package:cursapp/controllers/auth_controller.dart';
import 'package:cursapp/views/company_courses_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              AuthController().logout(context); // Cambiado para usar el logout
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CompanyCoursesScreen(companyCode: '1111'),
                  ),
                );
              },
              child: const Text('Ir a empresas'),
            ),
          ],
        ),
      ),
    );
  }
}
