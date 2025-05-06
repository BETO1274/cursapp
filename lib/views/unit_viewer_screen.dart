import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart'; // o el plugin que uses

class UnitViewerScreen extends StatelessWidget {
  final String pdfUrl;
  const UnitViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(title: const Text('Unidad')),
      path: pdfUrl,
    );
  }
}
