import 'package:flutter/material.dart';
import 'package:zc_dodiddone/Pages/login_page.dart';
import 'package:zc_dodiddone/Theme/theme.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}