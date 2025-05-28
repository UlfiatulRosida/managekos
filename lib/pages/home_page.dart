import 'package:flutter/material.dart'; //
import 'package:supabase_flutter/supabase_flutter.dart';

class Kos {
  // Model class untuk menyimpan data kos
  // Atribut yang dimiliki oleh kelas Kos
  final String id; // ID unik untuk setiap kos
  final String nama;
  final String alamat;

  Kos({
    // Konstruktor untuk kelas Kos
    required this.id,
    required this.nama,
    required this.alamat,
  });

  factory Kos.fromJson(Map<String, dynamic> json) {
    // Factory constructor untuk membuat objek Kos dari JSON
    // Mengambil data dari JSON dan mengonversinya ke tipe yang sesuai
    return Kos(
      // Mengembalikan objek Kos baru
      id: json['id']?.toString() ??
          '', // ID kos, jika tidak ada, gunakan string kosong
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
    // Navigasi ke halaman AddPage dengan data kos yang ada
    final result = await Navigator.pushNamed(context, '/add', arguments: kos);
    if (result == true) {
      // Jika berhasil menambahkan atau mengupdate data, refresh data
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kos Anda'),
      ),
      floatingActionButton: FloatingActionButton(
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
