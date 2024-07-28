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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksCollection.snapshots(),
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
          return const Center(child: Text('Нет задач, время отдыхать\n или создай задачу!'));
        }


        return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final taskData = tasks[index].data() as Map<String, dynamic>;
                    final taskTitle = taskData['title'];
                    final taskDescription = taskData['description'];
                    final taskDeadline =
                        (taskData['deadline'] as Timestamp).toDate();

                    return TaskItem(
                      title: taskTitle,
                      description: taskDescription,
                      deadline: taskDeadline,
                    );
                  },
        );
        
      },
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:zc_dodiddone/Widgets/task_item.dart';


// class TaskPage extends StatelessWidget {
//   const TaskPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Список задач
//     final List<String> tasks = [
//       'Купить продукты',
//       'Записаться на тренировку',
//       'Отправить отчет',
//     ];

//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Заголовок
//           const Text(
//             'Задачи',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Список задач
//           Expanded(
//             child: ListView.builder(
//               itemCount: tasks.length, // Используем длину массива tasks
//               itemBuilder: (context, index) {
//                 return TaskItem(
//                   title: tasks[index],
//                   description: 'Описание задачи',
//                   deadline: DateTime.now(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
