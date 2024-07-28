import 'package:flutter/material.dart';
import 'package:zc_dodiddone/services/firebace_auth.dart'; // Импортируем AuthService
import '../pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService(); // Создаем объект AuthService

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser(); // Получаем текущего пользователя

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Аватар
          CircleAvatar(
            radius: 50,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!) // Используем URL аватара, если он есть
                : const AssetImage('assets/_1.png'), // Иначе используем дефолтный аватар
          ),
          const SizedBox(height: 20),
          // Почта
          Text(
            user?.email ?? 'example@email.com', // Используем email пользователя, если он есть
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          // Кнопка подтверждения почты (отображается, если почта не подтверждена)
          if (!user!.emailVerified)
            ElevatedButton(
              onPressed: () async {
                // Отправляем запрос на подтверждение почты
                await _authService.sendEmailVerification();
                // Показываем диалог с сообщением о том, что письмо отправлено
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Подтверждение почты'),
                    content: const Text(
                        'Письмо с подтверждением отправлено на ваш адрес.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        ),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Подтвердить почту'),
            ),
          const SizedBox(height: 20),
          // Кнопка выхода из профиля
          ElevatedButton(
            onPressed: () async {
              // Выходим из системы
              await _authService.signOut();
              // Переходим на страницу входа
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Красный цвет для кнопки выхода
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}
