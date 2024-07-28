import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/Widgets/task_item.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // Функция для удаления задачи
  Future<void> _deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
      // Можно добавить сообщение об успешном удалении
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Задача удалена')),
      );
    } catch (e) {
      // Обработка ошибки удаления
      print('Ошибка удаления задачи: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления: $e')),
      );
    }
  }

  // Функция для редактирования задачи
  void _editTask(String taskId) {
    // Переход на страницу редактирования задачи
    Navigator.pushNamed(context, '/edit_task', arguments: taskId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksCollection.where('completed', isEqualTo: false).
      snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Ошибка загрузки задач'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Проверяем, есть ли данные в snapshot
        final tasks = snapshot.data!.docs;

        if (tasks.isEmpty) {
          return const Center(
              child: Text('Нет задач, время отдыхать\n или создай задачу!'));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final taskData = tasks[index].data() as Map<String, dynamic>;
            final taskId = tasks[index].id;
            final taskTitle = taskData['title'];
            final taskDescription = taskData['description'];
            final taskDeadline =
                (taskData['deadline'] as Timestamp).toDate();

            return Dismissible(
              key: Key(taskId), // Уникальный ключ для Dismissible
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
                color: Colors.blue,
                alignment: Alignment.centerLeft,
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  _deleteTask(taskId); // Вызываем _deleteTask при свайпе влево
                } else if (direction == DismissDirection.startToEnd) {
                  _editTask(taskId); // Вызываем _editTask при свайпе вправо
                }
              },
              child: TaskItem(
                title: taskTitle,
                description: taskDescription,
                deadline: taskDeadline,
                
                onEdit: () {
                  _editTask(taskId); // Вызываем _editTask при нажатии на кнопку редактирования
                },
                onDelete: () {
                  _deleteTask(taskId); // Вызываем _deleteTask при нажатии на кнопку удаления
                }, 
                to_left: (){
                  _tasksCollection
                  .doc(tasks[index].id)
                  .update({'completed': true});
                }, 
                to_right: (){
                  _tasksCollection
                  .doc(tasks[index].id)
                  .update({'is_for_today': true});
                },
              ),
            );
          },
        );
      },
    );
  }
}