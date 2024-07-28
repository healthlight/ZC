import 'package:flutter/material.dart';
import 'package:zc_dodiddone/Screens/all_tasks.dart';
import 'package:zc_dodiddone/Screens/profile.dart';
import 'package:zc_dodiddone/Theme/theme.dart';
import 'package:intl/intl.dart'; // Импортируем intl для работы с датой

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TaskPage(),
    Text('Сегодня'),
    Text('Выполнено'),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Контроллеры для диалогового окна
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  // Выбранная дата и время
  DateTime? _selectedDateTime;

  // Функция для открытия диалогового окна
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog( // Используем Dialog вместо AlertDialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Скругленные углы
          ),
          child: Container(
            width: 400, // Ширина диалогового окна
            padding: const EdgeInsets.all(20), // Отступ для содержимого
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
                        decoration:
                            const InputDecoration(labelText: 'Дедлайн'),
                        readOnly: true, // Делаем поле только для чтения
                        onTap: () async {
                          // Открываем календарь для выбора даты и времени
                          DateTime? pickedDateTime = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDateTime != null) {
                            // Открываем диалог выбора времени
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  pickedDateTime), // Используем выбранную дату
                            );

                            if (pickedTime != null) {
                              // Обновляем контроллер даты и времени
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
                    // Отступ для кнопки "Выбрать дедлайн"
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        // Открываем календарь для выбора даты и времени
                        DateTime? pickedDateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDateTime != null) {
                          // Открываем диалог выбора времени
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                pickedDateTime), // Используем выбранную дату
                          );

                          if (pickedTime != null) {
                            // Обновляем контроллер даты и времени
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
                    const SizedBox(width: 10), // Отступ между кнопками
                    TextButton(
                      onPressed: () {
                        // Обработка добавления задачи
                        // ...
                        Navigator.of(context).pop();
                      },
                      child: const Text('Добавить'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0, // Убираем тень
      ),
      body: Container( // Добавляем Container для градиента
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              DoDidDoneTheme.lightTheme.colorScheme.secondary,
              DoDidDoneTheme.lightTheme.colorScheme.primary,
            ],
            stops: const [0.1, 0.9],
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполнено',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
