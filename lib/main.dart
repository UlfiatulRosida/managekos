import 'package:flutter/material.dart';
import 'package:managekos/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
      //home: Scaffold(body: Center(child: Text("helo"))),
    );
  }
}
