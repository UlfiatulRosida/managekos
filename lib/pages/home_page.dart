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
  late Future<List<Kos>> _kosDataFuture; // Future untuk mengambil data kos

  Future<List<Kos>> fetchKosData() async {
    // Fungsi untuk mengambil data kos dari Supabase
    try {
      // Mengambil data dari tabel 'DataKos'
      final response = await Supabase.instance.client.from('DataKos').select();
      return (response as List)
          .map((json) => Kos.fromJson(json))
          .toList(); // Mengonversi data JSON menjadi daftar objek Kos
    } catch (e) {
      // Menangani kesalahan jika terjadi saat mengambil data
      throw Exception(
          'Gagal memuat data: $e'); // Melempar pengecualian jika terjadi kesalahan
    }
  }

  Future<void> _fetchData() async {
    // Fungsi memanggil fetchKosData untuk mengambil data kos dan memperbarui state
    setState(() {
      _kosDataFuture =
          fetchKosData(); // Menginisialisasi future dengan hasil dari fetchKosData
    });
  }

  @override // Metode yang dipanggil saat widget pertama kali dibuat
  void initState() {
    // Inisialisasi state
    super.initState(); // Memanggil metode initState dari superclass
    _fetchData(); // Memanggil fungsi untuk mengambil data kos
  }

  Future<void> _openAddPage(BuildContext context, Kos? kos) async {
    // Navigasi ke halaman AddPage dengan data kos yang ada
    final result = await Navigator.pushNamed(context, '/add', arguments: kos);
    if (result == true) {
      // Jika data berhasil disimpan, panggil _fetchData untuk memperbarui daftar
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Metode build untuk membangun tampilan halaman
    return Scaffold(
      // Scaffold adalah widget dasar untuk halaman
      appBar: AppBar(
        // AppBar adalah widget yang menampilkan bilah judul di bagian atas halaman
        title: const Text('Data Kos Anda'),
      ),
      floatingActionButton: FloatingActionButton(
        // Tombol aksi
        onPressed: () {
          // Fungsi yang dipanggil saat tombol ditekan
          _openAddPage(context, null); // Membuka halaman AddPage tanpa data kos
        },
        child: const Icon(Icons.add), // Ikon yang ditampilkan pada tombol
      ),
      body: FutureBuilder<List<Kos>>(
        // FutureBuilder untuk membangun tampilan berdasarkan hasil future
        // Menggunakan FutureBuilder untuk menampilkan daftar kos
        future: _kosDataFuture, // Future yang akan diambil datanya
        builder: (context, snapshot) {
          // Builder untuk membangun tampilan berdasarkan status future
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Jika koneksi masih menunggu
            // Menampilkan indikator pemuatan saat data masih dalam proses pengambilan
            return const Center(
                child: CircularProgressIndicator()); // Indikator pemuatan
          }
          if (snapshot.hasError) {
            // Jika terjadi kesalahan saat mengambil data
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // Menampilkan pesan kesalahan
          }
          if (snapshot.data!.isEmpty) {
            // Menampilkan pesan jika tidak ada data kos yang ditemukan
            return const Center(child: Text('Tidak ada data'));
          }
          return ListView.builder(
            // ListView untuk menampilkan daftar kos
            itemCount: snapshot.data!.length, // Jumlah item dalam daftar
            // Menggunakan ListView.builder untuk membuat daftar kos
            itemBuilder: (context, index) {
              // Builder untuk setiap item dalam daftar
              // Mengambil data kos berdasarkan indeks
              final kos =
                  snapshot.data![index]; // Mengambil objek Kos dari daftar
              // Mengembalikan widget Card untuk setiap kos
              return Card(
                // Card adalah widget yang menampilkan konten dalam bentuk kartu
                child: ListTile(
                  // ListTile adalah widget yang menampilkan item dalam daftar
                  title: Text(kos.nama), // Judul dari item daftar
                  subtitle: Text(kos.alamat), // Subjudul dari item daftar
                ),
              );
            },
          );
        },
      ),
    );
  }
}
