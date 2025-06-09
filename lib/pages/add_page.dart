import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:managekos/pages/edit_page.dart';

class Kos {
  final String id;
  final String nama;
  final String alamat;

  Kos({
    required this.id,
    required this.nama,
    required this.alamat,
  });

  factory Kos.fromJson(Map<String, dynamic> json) {
    return Kos(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
    );
  }
}

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late Future<List<Kos>> _kosDataFuture;

  Future<List<Kos>> fetchKosData() async {
    try {
      final response =
          await Supabase.instance.client.from('DataKos').select().order('nama');
      return (response as List).map((json) => Kos.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal memuat data: $e');
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _kosDataFuture = fetchKosData();
    });
  }

  Future<void> _addPage(BuildContext context, Kos? kos) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EditPage(),
          settings: RouteSettings(arguments: kos),
        ));
    if (result == true) {
      _fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Kos Anda')),
      floatingActionButton: FloatingActionButton(
        // Tombol aksi
        onPressed: () {
          _addPage(context, null);
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Kos>>(
        future: _kosDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final kos = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(kos.nama),
                    subtitle: Text(kos.alamat),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _addPage(context, kos);
                      },
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
