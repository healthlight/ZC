import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({
    Key? key,
    this.title,
    this.description,
    this.deadline,
    this.isEditing = false,
    this.taskId,
  }) : super(key: key);

  final String? title;
  final String? description;
  final DateTime? deadline;
  final bool isEditing;
  final String? taskId;

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  String? _title;
  String? _description;
  DateTime? _deadline;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  // Выбранная дата и время
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _description = widget.description;
    _deadline = widget.deadline;

    if (widget.isEditing) {
      _titleController.text = _title!;
      _descriptionController.text = _description!;
      _deadlineController.text = DateFormat('dd.MM.yyyy HH:mm').format(_deadline!);
      _selectedDateTime = _deadline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            // Поле для ввода даты и времени
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _deadlineController,
                    decoration: const InputDecoration(labelText: 'Дедлайн'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDateTime = await showDatePicker(
                        context: context,
                        initialDate: _selectedDateTime ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDateTime != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              pickedDateTime), // Используем выбранную дату
                        );

                        if (pickedTime != null) {
                          _selectedDateTime = DateTime(
                            pickedDateTime.year,
                            pickedDateTime.month,
                            pickedDateTime.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          _deadlineController.text =
                              DateFormat('dd.MM.yyyy HH:mm').format(
                                  _selectedDateTime!);
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    DateTime? pickedDateTime = await showDatePicker(
                      context: context,
                      initialDate: _selectedDateTime ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDateTime != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            pickedDateTime), // Используем выбранную дату
                      );

                      if (pickedTime != null) {
                        _selectedDateTime = DateTime(
                          pickedDateTime.year,
                          pickedDateTime.month,
                          pickedDateTime.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        _deadlineController.text =
                            DateFormat('dd.MM.yyyy HH:mm').format(
                                _selectedDateTime!);
                      }
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () async {
                    final title = _titleController.text;
                    final description = _descriptionController.text;
                    final deadline = _selectedDateTime;

                    if (title.isEmpty ||
                        description.isEmpty ||
                        deadline == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Заполните все поля'),
                        ),
                      );
                      return;
                    }

                    if (widget.isEditing) {
                      // Обновление задачи
                      try {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.taskId)
                            .update({
                          'title': title,
                          'description': description,
                          'deadline': Timestamp.fromDate(deadline),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Задача обновлена'),
                          ),
                        );
                      } catch (e) {
                        print('Ошибка обновления задачи: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка обновления: $e')),
                        );
                      }
                    } else {
                      // Добавление новой задачи
                      try {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .add({
                          'title': title,
                          'description': description,
                          'deadline': Timestamp.fromDate(deadline),
                          'completed': false,
                          'is_for_today': false,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Задача добавлена'),
                          ),
                        );
                      } catch (e) {
                        print('Ошибка добавления задачи: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка добавления: $e')),
                        );
                      }
                    }

                    // Очищаем контроллеры
                    _titleController.clear();
                    _descriptionController.clear();
                    _deadlineController.clear();
                    _selectedDateTime = null;

                    Navigator.of(context).pop();
                  },
                  child: Text(widget.isEditing ? 'Обновить' : 'Добавить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class DialogWidget extends StatefulWidget {
//   const DialogWidget({super.key, this.title, this.description, this.deadline});
//   final String? title;
//   final String? description;
//   final DateTime? deadline;

//   @override
//   State<DialogWidget> createState() => _DialogWidgetState();
// }

// class _DialogWidgetState extends State<DialogWidget> {
//   String? _title;
//   String? _description;
//   DateTime? _deadline;

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _deadlineController = TextEditingController();

 


//   // Выбранная дата и время
//   DateTime? _selectedDateTime;

//   @override
//   void initState() {
//     super.initState();
//     _title = widget.title;
//     _description = widget.description;
//     _deadline = widget.deadline;    
//   }



//   @override
//   Widget build(BuildContext context) {
//      _titleController.text = _title!;
//     _descriptionController.text = _description!; 
//     _deadlineController.text = DateFormat('dd.MM.yyyy HH:mm').format(
//                                       _deadline!);
//     return Dialog( // Используем Dialog вместо AlertDialog
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16), // Скругленные углы
//           ),
//           child: Container(
//             width: 400, // Ширина диалогового окна
//             padding: const EdgeInsets.all(20), // Отступ для содержимого
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(labelText: 'Название'),
//                 ),
//                 TextField(
//                   controller: _descriptionController,
//                   decoration: const InputDecoration(labelText: 'Описание'),
//                 ),
//                 // Поле для ввода даты и времени
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _deadlineController,
//                         decoration:
//                             const InputDecoration(labelText: 'Дедлайн'),
//                         readOnly: true, // Делаем поле только для чтения
//                         onTap: () async {
//                           // Открываем календарь для выбора даты и времени
//                           DateTime? pickedDateTime = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime.now(),
//                             lastDate: DateTime(2100),
//                           );

//                           if (pickedDateTime != null) {
//                             // Открываем диалог выбора времени
//                             TimeOfDay? pickedTime = await showTimePicker(
//                               context: context,
//                               initialTime: TimeOfDay.fromDateTime(
//                                   pickedDateTime), // Используем выбранную дату
//                             );

//                             if (pickedTime != null) {
//                               // Обновляем контроллер даты и времени
//                               _selectedDateTime = DateTime(
//                                 pickedDateTime.year,
//                                 pickedDateTime.month,
//                                 pickedDateTime.day,
//                                 pickedTime.hour,
//                                 pickedTime.minute,
//                               );
//                               _deadlineController.text =
//                                   DateFormat('dd.MM.yyyy HH:mm').format(
//                                       _selectedDateTime!);
//                             }
//                           }
//                         },
//                       ),
//                     ),
//                     // Отступ для кнопки "Выбрать дедлайн"
//                     const SizedBox(width: 10),
//                     IconButton(
//                       onPressed: () async {
//                         // Открываем календарь для выбора даты и времени
//                         DateTime? pickedDateTime = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime.now(),
//                           lastDate: DateTime(2100),
//                         );

//                         if (pickedDateTime != null) {
//                           // Открываем диалог выбора времени
//                           TimeOfDay? pickedTime = await showTimePicker(
//                             context: context,
//                             initialTime: TimeOfDay.fromDateTime(
//                                 pickedDateTime), // Используем выбранную дату
//                           );

//                           if (pickedTime != null) {
//                             // Обновляем контроллер даты и времени
//                             _selectedDateTime = DateTime(
//                               pickedDateTime.year,
//                               pickedDateTime.month,
//                               pickedDateTime.day,
//                               pickedTime.hour,
//                               pickedTime.minute,
//                             );
//                             _deadlineController.text =
//                                 DateFormat('dd.MM.yyyy HH:mm').format(
//                                     _selectedDateTime!);
//                           }
//                         }
//                       },
//                       icon: const Icon(Icons.calendar_today),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         // Обработка cansel задачи
//                         // ...
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text('Отмена'),
//                     ),
//                     const SizedBox(width: 10), // Отступ между кнопками
//                     TextButton(
                      
//                       onPressed: () async {
//                         // Получаем данные из контроллеров
//                         final title = _titleController.text;
//                         final description = _descriptionController.text;
//                         final deadline = _selectedDateTime;

//                         // Проверяем, что все поля заполнены
//                         if (title.isEmpty ||
//                             description.isEmpty ||
//                             deadline == null) {
//                           // Отображаем сообщение об ошибке
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Заполните все поля'),
//                             ),
//                           );
//                           return;
//                         }

//                         // Добавляем задачу в Firestore
//                         try {
//                           print('try to add task');
//                           await FirebaseFirestore.instance
//                               .collection('tasks')
//                               .add({
//                             'title': title,
//                             'description': description,
//                             'deadline': Timestamp.fromDate(deadline),
//                             'completed': false,
//                             'is_for_today': false,
//                           });

//                           // Очищаем контроллеры
//                           _titleController.clear();
//                           _descriptionController.clear();
//                           _deadlineController.clear();
//                           _selectedDateTime = null;

//                           // Закрываем диалоговое окно
//                           Navigator.of(context).pop();

//                           // Отображаем сообщение об успешном добавлении
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Задача добавлена'),
//                             ),
//                           );
//                         } catch (e) {
//                           // Обработка ошибки добавления
//                           print('Ошибка добавления задачи: $e');
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Ошибка добавления: $e')),
//                           );
//                         }
//                       },
//                       child: const Text('Добавить'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//   }
// }
