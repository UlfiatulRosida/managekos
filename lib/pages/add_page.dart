import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Kos {
  final String id;
  final String nama;
  final String alamat;
  final String kontakHp;
  final int nomorKamar;
  final int hargaSewa;
  final String tanggalMasuk;
// Model untuk menyimpan data kos
  Kos({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.kontakHp,
    required this.nomorKamar,
    required this.hargaSewa,
    required this.tanggalMasuk,
  }); // Konstruktor untuk inisialisasi data kos

  factory Kos.fromJson(Map<String, dynamic> json) {
    return Kos(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      kontakHp: json['kontakHp']?.toString() ?? '',
      nomorKamar: json['nomorKamar'] is int
          ? json['nomorKamar']
          : int.tryParse(json['nomorKamar'].toString()) ?? 0,
      hargaSewa: json['hargaSewa'] is int
          ? json['hargaSewa']
          : int.tryParse(json['hargaSewa'].toString()) ?? 0,
      tanggalMasuk: json['tanggalMasuk']?.toString() ?? '',
    ); // Mengonversi JSON menjadi objek Kos
  }
}

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
} // Untuk mendefinisikan widget AddPage yang merupakan halaman untuk menambah atau mengedit data kos

class _AddPageState extends State<AddPage> {
  late Future<List<Kos>>
      _kosDataFuture; // Untuk menyimpan future yang akan memuat data kos

  Future<List<Kos>> fetchKosData() async {
    try {
      final response = await Supabase.instance.client
          .from('DataKos')
          .select()
          .order(' nama');
      return (response as List).map((json) => Kos.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal memuat data: $e');
    } // Fungsi untuk mengambil data kos dari Supabase
  }

  Future<void> _fetchData() async {
    setState(() {
      _kosDataFuture = fetchKosData();
    });
  } // Untuk memperbarui future dengan data kos terbaru

  @override
  void initState() {
    super.initState();
    _fetchData();
  } // Inisialisasi state dengan memuat data kos saat halaman pertama kali dibuka

  Future<void> _addPage(BuildContext context, Kos? kos) async {
    final result = await Navigator.pushNamed(context, '/edit', arguments: kos);
    if (result == true) {
      _fetchData();
    }
  } // Untuk membuka halaman edit atau tambah data kos

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
    ); // Menampilkan dialog konfirmasi sebelum menghapus data

    if (confirmed == true) {
      final supabase = Supabase.instance.client;
      try {
        await supabase.from('DataKos').delete().eq(
            'id', kos.id); // Menghapus data kos dari Supabase berdasarkan ID

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dihapus')),
        ); // Menampilkan snackbar konfirmasi setelah data berhasil dihapus

        await _fetchData(); // refresh data setelah dihapus
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus data: $e')),
        );
      } // Menangani error jika terjadi kesalahan saat menghapus data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          title: const Text('Data Kos')),
      floatingActionButton: FloatingActionButton(
        // Tombol aksi
        onPressed: () {
          _addPage(context, null);
        },
        backgroundColor: Colors.blueGrey[50],
        child: const Icon(Icons.add, color: Colors.blueAccent, size: 35),
      ),
      body: FutureBuilder<List<Kos>>(
        // FutureBuilder untuk menampilkan data kos
        future: _kosDataFuture, // Menggunakan future yang telah diinisialisasi
        builder: (context, snapshot) {
          // Builder untuk membangun UI berdasarkan status future
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Jika masih dalam proses loading
            return const Center(
                child:
                    CircularProgressIndicator()); // Menampilkan indikator loading
          }
          if (snapshot.hasError) {
            // Jika terjadi error saat mengambil data
            return Center(child: Text('Error: ${snapshot.error}'));
          } // Jika ada error, tampilkan pesan error
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          } // Jika data kosong, tampilkan pesan tidak ada data
          return ListView.builder(
            // Untuk membangun daftar data kos
            itemCount: snapshot
                .data!.length, // Menghitung jumlah item yang akan ditampilkan
            itemBuilder: (context, index) {
              // Untuk membangun setiap item dalam daftar
              final kos =
                  snapshot.data![index]; // Mengambil data kos berdasarkan index
              return Card(
                // Membungkus setiap item dalam Card untuk tampilan yang lebih baik
                color: Colors.blueGrey[50],
                child: ListTile(
                  // Menampilkan data kos dalam ListTile
                  title: Text(kos.nama), // Menampilkan informasi lengkap
                  subtitle: Text(
                      'Alamat: ${kos.alamat}\nKontak: ${kos.kontakHp}\nKamar: ${kos.nomorKamar}\nHarga: Rp${kos.hargaSewa}\nMasuk: ${kos.tanggalMasuk}'),
                  isThreeLine: true, // lebih dari satu baris untuk subtitle
                  trailing: Row(
                    // menampilkan tombol aksi di sebelah kanan
                    mainAxisSize:
                        MainAxisSize.min, // minimalkan ukuran icon/baris
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () => _addPage(context, kos),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.blueGrey),
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
