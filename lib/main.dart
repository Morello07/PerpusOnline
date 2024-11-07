import 'package:flutter/material.dart';
import 'package:perpus_flutter/views/home.dart';
import 'package:perpus_flutter/views/login.dart';
import 'package:perpus_flutter/views/perpus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/home': (context) => Homepage(),
      '/perpus': (context) => PerpusPage(),
    },
    );
  }
}