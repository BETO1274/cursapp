import 'package:flutter/material.dart';
import '../../models/unit_model.dart';

class UnitListTile extends StatelessWidget {
  final UnitModel unit;

  const UnitListTile({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: Text(unit.title),
      subtitle: Text('${unit.pdfUrls.length} PDF(s)'),
      onTap: () {
        // Puedes abrir una nueva pantalla o previsualizar PDFs si deseas
      },
    );
  }
}
