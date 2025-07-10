import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/blog/cubit/task_cubit.dart';
import 'package:frontend/features/blog/pages/add_new_task.dart';
import 'package:frontend/features/blog/widgets/date_selector.dart';
import 'package:frontend/features/blog/widgets/task_card.dart';
import 'package:frontend/models/task_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentDate = DateTime.now();
  @override
  void initState() {
    AuthStateSuccess user = context.read<AuthCubit>().state as AuthStateSuccess;

    context.read<TasksCubit>().getAllTask(token: user.userModel.token);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Task'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewTask.route());
            },
            icon: const Icon(CupertinoIcons.add),
          )
        ],
      ),
      body: BlocBuilder<TasksCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TaskError) {
            return Center(
              child: Text(state.error),
            );
          }
          if (state is GetAllTaskSuccess) {
            final taskFilter = state.getTasks
                .where(
                  (elem) =>
                      DateFormat('d').format(elem.dueAt) ==
                          DateFormat('d').format(currentDate) &&
                      currentDate.month == elem.dueAt.month &&
                      currentDate.year == elem.dueAt.year,
                )
                .toList();

            return buildTaskBody(taskFilter);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget buildTaskBody(List<TaskModel> getTasks) {
    return Column(
      children: [
        DateSelector(
          currentDate: currentDate,
          onTap: (date) {
            setState(() {
              currentDate = date;
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: getTasks.length,
            itemBuilder: (context, index) {
              final tasks = getTasks[index];
              return buildTaskCard(tasks);
            },
          ),
        ),
      ],
    );
  }

  Widget buildTaskCard(TaskModel task) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TaskCard(
            colors: task.color,
            headerText: task.title,
            desc: task.description,
          ),
        ),
        Container(
          height: 10,
          width: 10,
          margin: const EdgeInsets.only(right: 14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: solidColor(Colors.red, 0.69),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            DateFormat.jm().format(task.dueAt),
            style: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        )
      ],
    );
  }
}
