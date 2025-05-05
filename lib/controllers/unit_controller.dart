import '../models/unit_model.dart';
import '../services/unit_service.dart';

class UnitController {
  final _service = UnitService();

  Future<void> addUnit({
    required String courseId,
    required String title,
    required String pdfPath,
  }) {
    return _service.createUnit(
      courseId: courseId,
      title: title,
      pdfPath: pdfPath,
    );
  }

  Future<List<UnitModel>> getUnits(String courseId) {
    return _service.fetchUnits(courseId);
  }
}
