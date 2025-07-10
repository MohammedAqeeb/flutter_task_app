part of 'task_cubit.dart';

sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class AddNewTaskSuccess extends TaskState {
  final TaskModel taskModel;

  AddNewTaskSuccess({required this.taskModel});
}

final class GetAllTaskSuccess extends TaskState {
  final List<TaskModel> getTasks;
  GetAllTaskSuccess({required this.getTasks});
}

final class TaskError extends TaskState {
  final String error;

  TaskError({required this.error});
}
