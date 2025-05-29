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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data != null
                  ? 'Data berhasil diupdate'
                  : 'Data berhasil ditambahkan')),
        );
        Navigator.pop(context, true); // Return true untuk trigger refresh
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Kos')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
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
                onPressed: _isLoading ? null : _saveData,
                child: _isLoading
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
