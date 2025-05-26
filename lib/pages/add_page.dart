import 'package:flutter/material.dart';
import 'package:managekos/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  Note? data;
  bool initialized = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController NamaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  String Nama = '';
  String Alamat = '';

  Future save() async {
    final supabase = Supabase.instance.client;
    String message = 'Berhasil menyimpan data kos';

    if (_formKey.currentState!.validate()) {
      if (data != null)
        await supabase.from('DataKos').update({
          'Nama': NamaController.text,
          'Alamat': _alamatController.text,
        }).eq('id', data!.id);
      message = 'Berhasil mengupdate data kos';
    } else {
      await supabase.from('DataKos').insert({
        'Nama': NamaController.text,
        'Alamat': _alamatController.text,
      });
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    Navigator.pop<String>(context, 'OK');
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as Note?;
    if (data != null && !initialized) {
      setState(() {
        Nama = data!.name;
        Alamat = data!.alamat;
      });
      initialized = true;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Kos Anda')),
      body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: NamaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _alamatController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: save,
                  child: const Text('Simpan'),
                ),
              ],
            ),
          )),
    );
  }
}
