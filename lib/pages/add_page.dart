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
  Kos? data;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  bool _isLoading = false;

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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final nama = _namaController.text.trim();
      final alamat = _alamatController.text.trim();

      if (data != null) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data != null
                  ? 'Data berhasil diupdate'
                  : 'Data berhasil ditambahkan')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> deleteData() async {
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus'),
              ),
            ],
          );
        });
    if (confirmed == true) {
      final supabase = Supabase.instance.client;
      await supabase.from('DataKos').delete().eq('id', data?.id ?? '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(data != null
                ? 'Data berhasil dihapus'
                : 'Data tidak ditemukan')),
      );
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${(data != null) ? 'Edit' : 'buat'} Catatan"),
        actions: (data != null)
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: deleteData, // Fungsi untuk menghapus data kos
                ),
              ]
            : [],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
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
    );
  }
}
