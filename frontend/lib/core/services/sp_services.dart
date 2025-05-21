import 'package:shared_preferences/shared_preferences.dart';

class SpServices {
  Future<void> setToken(String token) async {
    final prefers = await SharedPreferences.getInstance();
    prefers.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    final prefers = await SharedPreferences.getInstance();
    return prefers.getString('x-auth-token');
  }
}
