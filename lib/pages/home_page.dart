import 'package:flutter/material.dart';
import 'package:managekos/pages/add_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future fetchNote() async {
  final supabase = Supabase.instance.client;

  final data = await supabase.from('Datakos').select();
  return data;
}

class Note {
  final String id;
  final String name;
  final String description;

  const Note({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future manageKos;

  @override
  void initState() {
    super.initState();
    manageKos = fetchNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kos Anda'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, "/add"),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: manageKos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final note = Note.fromJson(snapshot.data[index]);
                  return ListTile(
                    title: Text(note.name),
                    subtitle: Text(note.description),
                    onTap: () {},
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
