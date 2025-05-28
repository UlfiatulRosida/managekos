import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future fetchNote() async {
  final supabase = Supabase.instance.client;

  final data = await supabase.from('DataKos').select();
  return data;
}

class Note {
  final String id;
  final String nama;
  final String alamat;

  const Note({
    required this.id,
    required this.nama,
    required this.alamat,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      nama: json['nama'] as String,
      alamat: json['alamat'] as String,
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

  Future<void> _AddPage(BuildContext context, Note? note) async {
    final result = await Navigator.pushNamed(context, '/add', arguments: note);
    if (result == 'OK') {
      setState(() {
        manageKos = fetchNote();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kos Anda'),
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
                    title: Text(note.nama),
                    subtitle: Text(note.alamat),
                    onTap: () {
                      _AddPage(context, note);
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _AddPage(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
