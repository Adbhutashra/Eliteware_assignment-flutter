import 'package:eliteware_assignment/Model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Interceptor {
  static Future<bool> authenticate(User user) async {
    // Simulate authentication success using shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'dummy_token');
    return true;
  }

  static Future<void> logout() async {
    // Simulate logout by clearing shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
