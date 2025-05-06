import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  final String pdfName;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.pdfName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pdfName)),
      body: const Center(child: CircularProgressIndicator()),
      // PDF Viewer
      bottomSheet: SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: const PDF().cachedFromUrl(
          pdfUrl,
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => Center(child: Text('Error al cargar el PDF: $error')),
        ),
      ),
    );
  }
}
