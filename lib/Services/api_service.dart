import 'package:eliteware_assignment/Model/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'https://your-api-url.com'; // Replace with your API URL

  static Future<bool> login(User user) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(url, body: user.toJson());
    return response.statusCode == 200;
  }
}
