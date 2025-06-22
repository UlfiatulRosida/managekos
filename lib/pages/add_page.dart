import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Kos {
  final String id;
  final String nama;
  final String alamat;
  final String kontakHp;
  final String nomorKamar;
  final String hargaSewa;
  final String tanggalMasuk;

  Kos({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.kontakHp,
    required this.nomorKamar,
    required this.hargaSewa,
    required this.tanggalMasuk,
  });

  factory Kos.fromJson(Map<String, dynamic> json) {
    return Kos(
      id: json['id']?.toString() ?? '',
      nama: json['nama_penghuni']?.toString() ?? '',
      alamat: json['alamat_penghuni']?.toString() ?? '',
      kontakHp: json['kontak_hp']?.toString() ?? '',
      nomorKamar: json['nomor_kamar'] ?? 0,
      hargaSewa: json['harga_sewa'] ?? 0,
      tanggalMasuk: json['tanggal_masuk']?.toString() ?? '',
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
      final response = await Supabase.instance.client
          .from('DataKos')
          .select()
          .order(' nama');
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

  Future<void> _addPage(BuildContext context, Kos? kos) async {
    final result = await Navigator.pushNamed(context, '/edit', arguments: kos);
    if (result == true) {
      _fetchData();
    }
  }

  Future<void> _delete(Kos kos) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text('Data yang dihapus tidak dapat dikembalikan'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final supabase = Supabase.instance.client;
      try {
        await supabase.from('DataKos').delete().eq('id', kos.id);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dihapus')),
        );
        Navigator.pop(context, 'OK');
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Kos')),
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
                  subtitle: Text(
                      'Alamat: ${kos.alamat}\nKontak: ${kos.kontakHp}\nKamar: ${kos.nomorKamar}\nHarga: Rp${kos.hargaSewa}\nMasuk: ${kos.tanggalMasuk}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _addPage(context, kos),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(kos),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
