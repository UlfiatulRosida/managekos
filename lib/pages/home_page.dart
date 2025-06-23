import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage(
      {super.key}); // Untuk mendefinisikan widget HomePage yang merupakan halaman utama setelah login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Untuk membuat struktur dasar halaman HomePage
      appBar: AppBar(
        // Untuk membuat AppBar di bagian atas halaman
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text('Managekos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Untuk menangani aksi logout saat tombol logout ditekan
              await Supabase.instance.client.auth
                  .signOut(); // Mengirim permintaan logout ke Supabase
              if (context.mounted) {
                // Memeriksa apakah konteks widget masih terpasang
                Navigator.pushReplacementNamed(context,
                    '/'); // Mengganti halaman saat ini dengan halaman login
              }
            },
            tooltip: "Logout", // Untuk memberikan tooltip pada tombol logout
          ),
        ],
      ),
      body: Center(
        // menempatkan konten di tengah halaman
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Selamat datang di Managekos!'),
            const SizedBox(
                height:
                    20), // Untuk memberi jarak vertikal antara teks dan tombol
            ElevatedButton(
              // Untuk membuat tombol untuk menambah catatan
              style: ElevatedButton.styleFrom(
                // Mengatur gaya tombol
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: // Untuk mengatur padding tombol
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                // Untuk menangani aksi saat tombol ditekan
                Navigator.pushNamed(context,
                    '/add'); // Mengarahkan pengguna ke halaman tambah catatan
              },
              child: const Text(
                  'Tambah Catatan'), // Teks yang ditampilkan pada tombol
            ),
          ],
        ),
      ),
    );
  }
}
