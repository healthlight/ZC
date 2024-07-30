import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/Pages/login_page.dart';
import 'package:zc_dodiddone/Pages/main_page.dart';
import 'package:zc_dodiddone/Screens/all_tasks.dart';
import 'package:zc_dodiddone/Theme/theme.dart';
import 'package:zc_dodiddone/services/firebace_auth.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _auth = AuthService();
  late User? user;


  @override
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    user = _auth.getCurrentUser();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home: user == null ? const LoginPage() : const MainPage()
    );
  }
}