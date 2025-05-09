import 'package:flutter/material.dart';
import 'package:managekos/pages/add_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kos Anda'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/add'),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddPage(),
                  settings: RouteSettings(arguments: "tambah"),
                ),
              ),
              child: Text("Tambah"),
            ),
            const Text(" ")
          ],
        ),
      ),
    );
  }
}
