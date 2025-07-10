import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskRepo {
  Future<TaskModel> createTask({
    required String title,
    required String desc,
    required String hexColor,
    required String token,
    required String uuid,
    required DateTime dueAt,
  }) async {
    try {
      final newTask = await http.post(
        Uri.parse('${Constants.endPoint}/tasks'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-header': token,
        },
        body: jsonEncode({
          'title': title,
          'description': desc,
          'hexColor': hexColor,
          'dueAt': dueAt.toIso8601String(),
        }),
      );

      if (newTask.statusCode != 201) {
        throw jsonDecode(newTask.body)['error'];
      }

      return TaskModel.fromJson(newTask.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<TaskModel>> getAllTask({
    required String token,
  }) async {
    try {
      List<TaskModel> getAllTask = [];
      final res = await http.get(
        Uri.parse('${Constants.endPoint}/tasks'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-header': token,
        },
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }

      final taskLists = jsonDecode(res.body);

      for (var taskMap in taskLists) {
        if (taskMap != null) {
          getAllTask.add(TaskModel.fromMap(taskMap));
        }
      }
      return getAllTask;
    } catch (e) {
      throw e.toString();
    }
  }
}
