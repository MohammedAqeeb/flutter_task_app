import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNewTask extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddNewTask());
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  DateTime defaultDate = DateTime.now();

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
                DateFormat('d-MM-yyyy').format(defaultDate),
              ),
            ),
          )
        ],
      ),
    );
  }
}
