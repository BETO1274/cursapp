import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'main_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final u = Provider.of<UserProvider>(context).user;
    return MainScaffold(
      currentIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('UID: ${u.uid}'),
          Text('Email: ${u.email}'),
          Text('Nombre: ${u.name ?? '-'}'),
          Text('Cargo: ${u.position ?? '-'}'),
          Text('Empresa: ${u.companyCode ?? '-'}'),
        ]),
      ),
    );
  }
}
