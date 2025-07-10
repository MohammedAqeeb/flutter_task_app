import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/blog/repository/task_repo.dart';
import 'package:frontend/models/task_model.dart';

part 'task_state.dart';

class TasksCubit extends Cubit<TaskState> {
  TasksCubit() : super(TaskInitial());

  final taskRepo = TaskRepo();

  Future<void> newTask({
    required String title,
    required String desc,
    required Color hexColor,
    required String token,
    required String uuid,
    required DateTime dueAt,
  }) async {
    try {
      emit(TaskLoading());
      final createTask = await taskRepo.createTask(
        title: title,
        desc: desc,
        hexColor: rgbToHex(hexColor),
        token: token,
        uuid: uuid,
        dueAt: dueAt,
      );

      emit(AddNewTaskSuccess(taskModel: createTask));
    } catch (e) {
      emit(TaskError(error: e.toString()));
    }
  }

  Future<void> getAllTask({
    required String token,
  }) async {
    try {
      emit(TaskLoading());
      final taskList = await taskRepo.getAllTask(token: token);

      emit(GetAllTaskSuccess(getTasks: taskList));
    } catch (e) {
      emit(TaskError(error: e.toString()));
    }
  }
}
