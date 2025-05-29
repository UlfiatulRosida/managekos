import 'package:flutter/material.dart';
import 'package:managekos/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

final supabase = Supabase.instance.client;

class _AddPageState extends State<AddPage> {
  Kos? data; // Data kos yang akan ditambahkan atau diupdate
  final _formKey = GlobalKey<
      FormState>(); // Key untuk mengidentifikasi form dan melakukan validasi
  final TextEditingController _namaController =
      TextEditingController(); // Controller untuk mengelola input nama kos
  final TextEditingController _alamatController = TextEditingController();
  bool _isLoading =
      false; // Status loading untuk menampilkan indikator saat proses simpan data

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Kos) {
      data = args;
      _namaController.text = data!.nama;
      _alamatController.text = data!.alamat;
    }
  }

  Future<void> _saveData() async {
    // Fungsi untuk menyimpan data kos
    if (!_formKey.currentState!.validate())
      return; // Validasi form sebelum menyimpan data

    setState(() => _isLoading =
        true); // Set status loading menjadi true untuk menampilkan indikator loading

    try {
      // Mengambil instance Supabase client untuk berinteraksi dengan database
      final supabase = Supabase.instance.client;
      final nama = _namaController.text.trim();
      final alamat = _alamatController.text.trim();

      if (data != null) {
        // Update existing data
        await supabase
            .from('DataKos')
            .update({'nama': nama, 'alamat': alamat}).eq('id', data!.id);
      } else {
        // Insert new data
        await supabase.from('DataKos').insert({
          'nama': nama,
          'alamat': alamat,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      if (mounted) {
        // Cek apakah widget masih terpasang sebelum menampilkan snackbar
        // Tampilkan snackbar untuk memberi tahu pengguna bahwa data berhasil disimpan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data != null
                  ? 'Data berhasil diupdate'
                  : 'Data berhasil ditambahkan')),
        );
        Navigator.pop(context, true); // Return true untuk trigger refresh
      }
    } catch (e) {
      // Tangani kesalahan jika terjadi saat menyimpan data
      if (mounted) {
        // Cek apakah widget masih terpasang sebelum menampilkan snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error: ${e.toString()}')), // Tampilkan snackbar dengan pesan error
        );
      }
    } finally {
      // Set status loading menjadi false setelah proses selesai
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // Dispose controller untuk menghindari memory leak
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Kos')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key:
              _formKey, // Menggunakan key untuk form agar bisa melakukan validasi
          child: Column(
            // Membuat kolom untuk menampung widget input
            children: [
              TextFormField(
                // Input field untuk nama kos
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => // Validasi input nama kos
                    value?.isEmpty ?? true
                        ? 'Nama wajib diisi'
                        : null, // Jika kosong, tampilkan pesan error
              ),
              const SizedBox(height: 16), // Jarak antar input
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Alamat wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                // Tombol untuk menyimpan data kos
                onPressed: _isLoading
                    ? null
                    : _saveData, // Nonaktifkan tombol jika sedang loading
                child:
                    _isLoading // Tampilkan indikator loading jika sedang proses simpan data
                        ? const CircularProgressIndicator()
                        : const Text('Simpan Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
