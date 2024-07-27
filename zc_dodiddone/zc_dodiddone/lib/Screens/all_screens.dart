import 'package:flutter/material.dart';
import 'package:zc_dodiddone/Widgets/task_item.dart';


class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Список задач
    final List<String> tasks = [
      'Купить продукты',
      'Записаться на тренировку',
      'Отправить отчет',
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          const Text(
            'Задачи',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Список задач
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length, // Используем длину массива tasks
              itemBuilder: (context, index) {
                return TaskItem(
                  title: tasks[index],
                  description: 'Описание задачи',
                  deadline: DateTime.now(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
