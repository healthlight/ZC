import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Объект для работы с Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // // Объект для работы с Google Sign-In
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Метод для регистрации с помощью email и пароля
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      // Регистрируем пользователя в Firebase
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок
      print('Ошибка регистрации: ${e.code}');
      return null;
    }
  }

  // Метод для входа с помощью email и пароля
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Входим в Firebase с помощью email и пароля
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок
      print('Ошибка входа: ${e.code}');
      return null;
    }
  }

  // Метод для отправки запроса на подтверждение почты
  Future<void> sendEmailVerification() async {
    // Получаем текущего пользователя
    final user = _auth.currentUser;

    // Если пользователь авторизован
    if (user != null) {
      // Отправляем запрос на подтверждение почты
      await user.sendEmailVerification();
    }
  }

  // Метод для выхода из системы
  Future<void> signOut() async {
    // Выходим из Firebase Authentication
    await _auth.signOut();

    // // Выходим из Google Sign-In
    // await _googleSignIn.signOut();
  }

  // Метод для получения текущего пользователя
  User? getCurrentUser() {
    // Возвращаем текущего пользователя, если он авторизован
    return _auth.currentUser;
  }
}
