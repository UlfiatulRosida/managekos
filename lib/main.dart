import 'package:flutter/material.dart';
import 'package:managekos/pages/home_page.dart';
import 'package:managekos/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'managekos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
      //home: Scaffold(body: Center(child: Text("helo"))),
    );
  }
}
