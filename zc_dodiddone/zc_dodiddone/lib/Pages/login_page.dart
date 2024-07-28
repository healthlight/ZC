import 'package:flutter/material.dart';
import 'package:zc_dodiddone/Pages/main_page.dart';
import 'package:zc_dodiddone/Theme/theme.dart';
import 'package:zc_dodiddone/services/firebace_auth.dart'; // Импортируем AuthService

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true; // Flag to indicate login or registration
  final AuthService _authService = AuthService(); // Создаем объект AuthService

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Освобождаем контроллер
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isLogin
                ? [
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                    DoDidDoneTheme.lightTheme.colorScheme.primary,
                  ]
                : [
                    DoDidDoneTheme.lightTheme.colorScheme.primary,
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                  ],
            stops: const [0.1, 0.9],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/zero_coder.png'),
                    const SizedBox(width: 10),
                    // White text Zerocoder
                    Text(
                      'Zerocoder',
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Название приложения с RichText
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'do',
                        style: TextStyle(
                          color: DoDidDoneTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      TextSpan(
                        text: '-did-',
                        style: const TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'done',
                        style: TextStyle(
                          color: DoDidDoneTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Адрес электронной почты', // Изменили подсказку
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите адрес электронной почты';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                        .hasMatch(value)) {
                      return 'Некорректный адрес электронной почты';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Пароль',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите пароль';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Условие для отображения поля "Повторить пароль"
                if (!_isLogin) // Отображаем только при _isLogin == true
                  TextFormField(
                    controller: _confirmPasswordController,
                    // Используем новый контроллер
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Повторить пароль', // Новая подсказка
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, повторите пароль';
                      }
                      if (value != _passwordController.text) {
                        return 'Пароли не совпадают';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_isLogin) {
                        // Вход в систему
                        final userCredential =
                            await _authService.signInWithEmailAndPassword(
                          _usernameController.text,
                          _passwordController.text,
                        );
                        if (userCredential != null) {
                          // Успешный вход
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainPage(),
                            ),
                          );
                        } else {
                          // Ошибка входа
                          // Выведите сообщение об ошибке
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ошибка входа'),
                            ),
                          );
                        }
                      } else {
                        // Регистрация
                        final userCredential =
                            await _authService.registerWithEmailAndPassword(
                          _usernameController.text,
                          _passwordController.text,
                        );
                        if (userCredential != null) {
                          // Успешная регистрация
                          // Отправьте запрос на подтверждение почты
                          await _authService.sendEmailVerification();
                          // Выведите сообщение об успешной регистрации
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Регистрация успешна'),
                              
                            )
                          );              
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainPage(),
                            ),            
                          );
                        } else {
                          // Ошибка регистрации
                          // Выведите сообщение об ошибке
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ошибка регистрации'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _isLogin
                        ? DoDidDoneTheme.lightTheme.colorScheme.primary
                        : DoDidDoneTheme.lightTheme.colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(_isLogin ? 'Войти' : 'Зарегистрироваться'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin; // Toggle login/registration
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'У меня еще нет аккаунта...'
                        : 'Уже есть аккаунт...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
