import 'package:flutter/material.dart';
import 'package:managekos/pages/add_page.dart'; // Untuk mengimpor halaman AddPage
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
} // Untuk mendefinisikan widget EditPage yang merupakan halaman untuk mengedit data kos

class _EditPageState extends State<EditPage> {
  Kos? data; // Untuk menyimpan data kos yang akan diedit
  late final TextEditingController _namaController;
  late final TextEditingController _alamatController;
  late final TextEditingController _kontakHpController;
  late final TextEditingController _nomorKamarController;
  late final TextEditingController _hargaSewaController;
  late final TextEditingController
      _tanggalMasukController; // Kontroler untuk input teks

  final _formKey = GlobalKey<FormState>(); // Untuk mengelola status form

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _alamatController = TextEditingController();
    _kontakHpController = TextEditingController();
    _nomorKamarController = TextEditingController();
    _hargaSewaController = TextEditingController();
    _tanggalMasukController =
        TextEditingController(); // Inisialisasi kontroler untuk input teks

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Untuk memastikan data diambil setelah widget dibangun
      final args = ModalRoute.of(context)
          ?.settings
          .arguments; // Mengambil argumen dari rute saat ini
      if (args is Kos) {
        // Memeriksa apakah argumen adalah objek Kos
        data = args; // Menyimpan data kos yang akan diedit
        _namaController.text = data?.nama ?? '';
        _alamatController.text = data?.alamat ?? '';
        _kontakHpController.text = data!.kontakHp;
        _nomorKamarController.text = data!.nomorKamar.toString();
        _hargaSewaController.text = data!.hargaSewa.toString();
        _tanggalMasukController.text = data!.tanggalMasuk;
      }
    });
  } // Untuk menginisialisasi kontroler dan mengambil data kos yang akan diedit

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _kontakHpController.dispose();
    _nomorKamarController.dispose();
    _hargaSewaController.dispose();
    _tanggalMasukController.dispose();
    super.dispose();
  } // Untuk membersihkan kontroler saat widget dihapus dari pohon widget

  Future<void> save() async {
    // Untuk menyimpan data kos yang telah diisi atau diedit
    if (_formKey.currentState!.validate()) {
      // Memeriksa apakah form valid
      final supabase = Supabase.instance.client; // Inisialisasi klien Supabase

      try {
        // Untuk menangani penyimpanan data kos
        if (data != null && data!.id.isNotEmpty) {
          // jika data kos sudah ada
          // Update data kos yang sudah ada
          await supabase.from('DataKos').update({
            // Untuk memperbarui data kos
            'nama': _namaController.text,
            'alamat': _alamatController.text,
            'kontakHp': _kontakHpController.text,
            'nomorKamar': int.tryParse(_nomorKamarController.text) ??
                0, // Mengonversi nomor kamar ke integer
            'hargaSewa': int.tryParse(_hargaSewaController.text) ?? 0,
            'tanggalMasuk': _tanggalMasukController.text,
          }).eq('id', data!.id); // Untuk memperbarui data berdasarkan ID
        } else {
          // jika data kos belum ada (tambah data baru)
          await supabase.from('DataKos').insert({
            'nama': _namaController.text,
            'alamat': _alamatController.text,
            'kontakHp': _kontakHpController.text,
            'nomorKamar': int.tryParse(_nomorKamarController.text) ?? 0,
            'hargaSewa': int.tryParse(_hargaSewaController.text) ?? 0,
            'tanggalMasuk': _tanggalMasukController.text,
          }); // Untuk menyimpan data kos baru
        }
        if (!mounted) {
          return; // Memastikan widget masih terpasang sebelum menampilkan snackbar
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Berhasil Disimpan')),
        ); // Menampilkan snackbar
        Navigator.pop(context,
            true); // Kembali ke halaman sebelumnya dengan mengirimkan nilai true
      } catch (e) {
        // Menangani error jika terjadi kesalahan saat menyimpan data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: Text(data != null
            ? 'Edit data'
            : 'Tambah data'), // AppBar akan berubah sesuai dengan apakah data ada atau tidak
      ),
      body: Form(
        key: _formKey, // Untuk mengelola status form
        child: ListView(
          padding: const EdgeInsets.all(
              16.0), // Untuk memberi jarak pada konten form
          children: [
            // Untuk membuat form input data kos
            TextFormField(
              // Untuk input nama kos
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(), // Untuk memberi border pada input
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(
                height: 16), // Untuk memberi jarak vertikal antara input
            TextFormField(
              controller: _alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Alamat wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kontakHpController,
              decoration: const InputDecoration(
                labelText: 'Kontak HP',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Kontak HP wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomorKamarController,
              decoration: const InputDecoration(
                labelText: 'Nomor Kamar',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Nomor Kamar wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hargaSewaController,
              decoration: const InputDecoration(
                labelText: 'Harga Sewa',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Harga Sewa wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tanggalMasukController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Masuk',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Tanggal Masuk wajib diisi' : null,
            ),
            const SizedBox(
                height:
                    24), // Untuk memberi jarak vertikal sebelum tombol simpan
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(vertical: 14), //
              ),
              onPressed: save,
              child: const Text('Simpan',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
