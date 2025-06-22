import 'package:flutter/material.dart';
import 'package:managekos/pages/add_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Kos? data;
  late final TextEditingController _namaController;
  late final TextEditingController _alamatController;
  late final TextEditingController _kontakHpController;
  late final TextEditingController _nomorKamarController;
  late final TextEditingController _hargaSewaController;
  late final TextEditingController _tanggalMasukController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _alamatController = TextEditingController();
    _kontakHpController = TextEditingController();
    _nomorKamarController = TextEditingController();
    _hargaSewaController = TextEditingController();
    _tanggalMasukController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Kos) {
        data = args;
        _namaController.text = data?.nama ?? '';
        _alamatController.text = data?.alamat ?? '';
        _kontakHpController.text = data!.kontakHp;
        _nomorKamarController.text = data!.nomorKamar.toString();
        _hargaSewaController.text = data!.hargaSewa.toString();
        _tanggalMasukController.text = data!.tanggalMasuk;
      }
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _kontakHpController.dispose();
    _nomorKamarController.dispose();
    _hargaSewaController.dispose();
    _tanggalMasukController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (_formKey.currentState!.validate()) {
      final supabase = Supabase.instance.client;

      try {
        if (data != null && data!.id.isNotEmpty) {
          await supabase.from('DataKos').update({
            'nama': _namaController.text,
            'alamat': _alamatController.text,
            'kontakHp': _kontakHpController.text,
            'nomorKamar': _nomorKamarController,
            'hargaSewa': _hargaSewaController.text,
            'tanggalMasuk': _tanggalMasukController.text,
          }).eq('id', data!.id);
        } else {
          await supabase.from('DataKos').insert({
            'nama': _namaController.text,
            'alamat': _alamatController.text,
            'kontakHp': _kontakHpController.text,
            'nomorKamar': int.tryParse(_nomorKamarController.text) ?? 0,
            'hargaSewa': int.tryParse(_hargaSewaController.text) ?? 0,
            'tanggalMasuk': _tanggalMasukController.text,
          });
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Berhasil Disimpan')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data != null ? 'Edit data' : 'Tambah data'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 12),
            TextFormField(
              controller: _alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Alamat wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _kontakHpController,
              decoration: const InputDecoration(
                labelText: 'Kontak HP',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Kontak HP wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nomorKamarController,
              decoration: const InputDecoration(
                labelText: 'Nomor Kamar',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Nomor Kamar wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _hargaSewaController,
              decoration: const InputDecoration(
                labelText: 'Harga Sewa',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Harga SEwa wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tanggalMasukController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Masuk',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Tanggal Masuk wajib diisi' : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: save,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
