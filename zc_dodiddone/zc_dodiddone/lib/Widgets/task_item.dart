
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final String title;
  final String description;
  final DateTime deadline;
  final VoidCallback onEdit; // Добавляем onEdit
  final VoidCallback onDelete; // Добавляем onDelete
  final Function? to_left;
  final Function? to_right;

  const TaskItem({
    Key? key,
    required this.title,
    required this.description,
    required this.deadline,
    required this.onEdit, // Передаем onEdit
    required this.onDelete, // Передаем onDelete
    required this.to_left,
    required this.to_right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Форматируем дату и время с помощью intl
    String formattedDeadline = DateFormat('dd.MM.yy HH:mm').format(deadline);

    // Определяем градиент в зависимости от срочности
    Gradient gradient = getGradient(deadline);

    return Dismissible(
      key: Key(title), // Уникальный ключ для Dismissible
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          to_left?.call(); // Вызываем to_left при свайпе влево
        } else if (direction == DismissDirection.startToEnd) {
          to_right?.call(); // Вызываем to_right при свайпе вправо
        }
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // Добавляем Container для градиента
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  // Добавляем кнопки "Выполнено" и "Редактировать" в заголовок
                  IconButton(
                    onPressed: () {
                      // Обработка нажатия на кнопку "Выполнено"
                      // Например, можно удалить задачу из списка
                      print('Задача выполнена!');
                    },
                    icon: const Icon(Icons.check_circle),
                  ),
                  IconButton(
                    onPressed: () {
                      // Обработка нажатия на кнопку "Редактировать"
                      // Например, можно открыть диалог редактирования задачи
                      print('Задача редактируется!');
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Дедлайн: $formattedDeadline',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Функция для получения градиента в зависимости от срочности
  Gradient getGradient(DateTime deadline) {
    Duration timeUntilDeadline = deadline.difference(DateTime.now());

    if (timeUntilDeadline.inDays <= 1) {
      return const LinearGradient(
        colors: [Colors.red, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (timeUntilDeadline.inDays <= 2) {
      return const LinearGradient(
        colors: [Colors.yellow, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Colors.green, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class TaskItem extends StatelessWidget {
//   final String title;
//   final String description;
//   final DateTime deadline;

//   const TaskItem({
//     Key? key,
//     required this.title,
//     required this.description,
//     required this.deadline,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Форматируем дату и время с помощью intl
//     String formattedDeadline = DateFormat('dd.MM.yy HH:mm').format(deadline);

//     // Определяем градиент в зависимости от срочности
//     Gradient gradient = getGradient(deadline);

//     return Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             // Добавляем Container для градиента
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             decoration: BoxDecoration(
//               gradient: gradient,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8.0),
//                 topRight: Radius.circular(8.0),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 0, 0, 0),
//                     ),
//                   ),
//                 ),
//                 // Добавляем кнопки "Выполнено" и "Редактировать" в заголовок
//                 IconButton(
//                   onPressed: () {
//                     // Обработка нажатия на кнопку "Выполнено"
//                     // Например, можно удалить задачу из списка
//                     print('Задача выполнена!');
//                   },
//                   icon: const Icon(Icons.check_circle),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     // Обработка нажатия на кнопку "Редактировать"
//                     // Например, можно открыть диалог редактирования задачи
//                     print('Задача редактируется!');
//                   },
//                   icon: const Icon(Icons.edit),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   description,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Дедлайн: $formattedDeadline',
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   // Функция для получения градиента в зависимости от срочности
//   Gradient getGradient(DateTime deadline) {
//     Duration timeUntilDeadline = deadline.difference(DateTime.now());

//     if (timeUntilDeadline.inDays <= 1) {
//       return const LinearGradient(
//         colors: [Colors.red, Colors.white],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       );
//     } else if (timeUntilDeadline.inDays <= 2) {
//       return const LinearGradient(
//         colors: [Colors.yellow, Colors.white],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       );
//     } else {
//       return const LinearGradient(
//         colors: [Colors.green, Colors.white],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       );
//     }
//   }
// }