import '../models/user.model.dart';
import '../services/user_service.dart';

class ProfileController {
  final _service = UserService();

  Future<void> updateProfile(UserModel user) {
    return _service.updateProfile(user);
  }
}
