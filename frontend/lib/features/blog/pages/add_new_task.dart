import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/blog/cubit/task_cubit.dart';
import 'package:frontend/features/blog/pages/home_page.dart';
import 'package:intl/intl.dart';

class AddNewTask extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddNewTask());
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final formKey = GlobalKey<FormState>();

  DateTime defaultDate = DateTime.now();
  Color defaultColor = Colors.white;

  TextEditingController taskController = TextEditingController();
  TextEditingController desController = TextEditingController();

  void validateTask() async {
    if (formKey.currentState!.validate()) {
      AuthStateSuccess user =
          context.read<AuthCubit>().state as AuthStateSuccess;
      await context.read<TasksCubit>().newTask(
            title: taskController.text.trim(),
            desc: desController.text.trim(),
            hexColor: defaultColor,
            token: user.userModel.token,
            uuid: user.userModel.id,
            dueAt: defaultDate,
          );
    }
  }

  @override
  void dispose() {
    taskController.dispose();
    desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                firstDate: defaultDate,
                currentDate: defaultDate,
                lastDate: DateTime.now().add(
                  const Duration(days: 90),
                ),
              );

              if (selectedDate != null) {
                setState(() {
                  defaultDate = selectedDate;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                DateFormat('MM-d-y').format(defaultDate),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<TasksCubit, TaskState>(
          listener: (context, state) {
            if (state is TaskError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            } else if (state is AddNewTaskSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('New Task Added'),
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                HomePage.route(),
                (_) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return buildBody(context);
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: taskController,
              decoration: const InputDecoration(
                hintText: 'Task Title',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Title cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: desController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Description cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            ColorPicker(
              heading: const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Select Color'),
              ),
              subheading: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Select Shades'),
              ),
              onColorChanged: (color) {
                setState(() {
                  defaultColor = color;
                });
              },
              crossAxisAlignment: CrossAxisAlignment.center,
              pickersEnabled: const {
                ColorPickerType.wheel: true,
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: validateTask,
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
