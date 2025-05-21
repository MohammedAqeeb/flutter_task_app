import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/blog/pages/add_new_task.dart';
import 'package:frontend/features/blog/widgets/date_selector.dart';
import 'package:frontend/features/blog/widgets/task_card.dart';

class HomePage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

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
      body: Column(
        children: [
          const DateSelector(),
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: TaskCard(
                    colors: Color.fromRGBO(234, 209, 151, 1),
                    headerText: 'headerText',
                    desc:
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum'),
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
              const Expanded(
                flex: 1,
                child: Text(
                  '12 Sept 2025',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
