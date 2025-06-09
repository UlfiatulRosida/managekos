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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _alamatController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Kos) {
        data = args;
        _namaController.text = data?.nama ?? '';
        _alamatController.text = data?.alamat ?? '';
      }
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future save() async {
    if (_formKey.currentState!.validate()) {
      final supabase = Supabase.instance.client;

      try {
        if (data != null && data!.id.isNotEmpty) {
          await supabase.from('DataKos').update({
            'nama': _namaController.text,
            'alamat': _alamatController.text
          }).eq('id', data!.id);
        } else {
          await supabase.from('DataKos').insert({
            'nama': _namaController.text,
            'alamat': _alamatController.text,
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

  Future delete() async {
    if (data == null || data!.id.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data tidak valid untuk dihapus')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data?'),
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
        await supabase.from('DataKos').delete().eq('id', data!.id);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Berhasil Dihapus')),
        );
        Navigator.pop<String>(context, 'OK');
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
      appBar: AppBar(
        title: Text("${(data != null) ? 'Edit' : 'Buat'} Data Kos"),
        actions: (data != null)
            ? [
                IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: delete),
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Kos',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Alamat wajib diisi' : null,
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
