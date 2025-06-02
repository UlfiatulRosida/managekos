import 'package:flutter/material.dart'; //
import 'package:supabase_flutter/supabase_flutter.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Kos>> _kosDataFuture;

  Future<List<Kos>> fetchKosData() async {
    try {
      final response = await Supabase.instance.client.from('DataKos').select();
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

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _openAddPage(BuildContext context, Kos? kos) async {
    final result = await Navigator.pushNamed(context, '/add', arguments: kos);
    if (result == true) {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Kos Anda')),
      floatingActionButton: FloatingActionButton(
        // Tombol aksi
        onPressed: () {
          _openAddPage(context, null);
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
