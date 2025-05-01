import 'package:flutter/material.dart';
import 'package:managekos/pages/add_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        action: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/add'),
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
