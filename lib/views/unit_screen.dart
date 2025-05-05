import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../controllers/unit_controller.dart';
import '../models/unit_model.dart';

class UnitScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final String currentUserId;
  final String creatorId;

  const UnitScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.currentUserId,
    required this.creatorId,
  });

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  final _unitCtrl = UnitController();
  final _titleCtrl = TextEditingController();
  List<UnitModel> _units = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final units = await _unitCtrl.getUnits(widget.courseId);
    setState(() {
      _units = units;
      _loading = false;
    });
  }

  Future<void> _addUnit() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final title = await _showTitleDialog();
      if (title != null && title.isNotEmpty) {
        await _unitCtrl.addUnit(courseId: widget.courseId, title: title, pdfPath: path);
        _loadUnits();
      }
    }
  }

  Future<String?> _showTitleDialog() {
    _titleCtrl.clear();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unit Title'),
        content: TextField(controller: _titleCtrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, _titleCtrl.text), child: const Text('Save')),
        ],
      ),
    );
  }

 void _openPdf(String url) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => PdfViewerScreen(pdfUrl: url)),
  );
}


  @override
  Widget build(BuildContext context) {
    final isCreator = widget.currentUserId == widget.creatorId;

    return Scaffold(
      appBar: AppBar(title: Text(widget.courseTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _units.isEmpty
              ? const Center(child: Text('No units yet.'))
              : ListView.builder(
                  itemCount: _units.length,
                  itemBuilder: (context, index) {
                    final unit = _units[index];
                    return ListTile(
                      title: Text(unit.title),
                      trailing: const Icon(Icons.picture_as_pdf),
                      onTap: () => _openPdf(unit.pdfUrl),
                    );
                  },
                ),
      floatingActionButton: isCreator
          ? FloatingActionButton(
              onPressed: _addUnit,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
