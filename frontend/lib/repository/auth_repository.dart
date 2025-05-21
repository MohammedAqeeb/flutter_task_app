import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/services/sp_services.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/repository/auth_local_repository.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final spService = SpServices();
  final localRepo = AuthLocalRepository();

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.endPoint}/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.endPoint}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();

      if (token == null) {
        return null;
      }

      final res = await http.post(
        Uri.parse('${Constants.endPoint}/auth/isTokenValid'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-header': token,
        },
      );

      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }

      final userData = await http.get(
        Uri.parse('${Constants.endPoint}/auth'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-header': token,
        },
      );

      if (userData.statusCode != 200) {
        throw jsonDecode(userData.body)['error'];
      }
      return UserModel.fromJson(userData.body);
    } catch (e) {
      final user = await localRepo.getUser();
      return user;
    }
  }
}
