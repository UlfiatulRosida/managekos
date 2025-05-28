import 'package:flutter/material.dart'; // Mengimpor paket Flutter komponen UI Material Design
import 'package:managekos/pages/login_page.dart';
import 'package:managekos/pages/home_page.dart';
import 'package:managekos/pages/add_page.dart'; // Mengimpor halaman login, home, dan add
import 'package:supabase_flutter/supabase_flutter.dart'; // Mengimpor paket Supabase untuk koneksi ke database

const String supabaseKey = // Kunci anon untuk mengakses Supabase
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhic2FzcXV5eHpldmNkcW1oeGZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2NzU3MjcsImV4cCI6MjA2MTI1MTcyN30.fDSLwsn0G2jUb82HhTEwsxYdng_3cDsdR7QxtRNPCOg';
Future<void> main() async {
  //
  // Fungsi utama untuk menjalankan aplikasi Flutter
  await Supabase.initialize(
      // memastikan koneksi ke Supabase
      url: 'https://hbsasquyxzevcdqmhxfp.supabase.co',
      anonKey: supabaseKey);
  runApp(const MainApp()); // menjalankan aplikasi Flutter
}

class MainApp extends StatelessWidget {
  // Kelas utama aplikasi yang merupakan turunan dari StatelessWidget
  // Konstruktor untuk MainApp
  const MainApp(
      {super.key}); // Konstruktor untuk MainApp, menerima key sebagai parameter

  @override // Metode build untuk membangun widget aplikasi
  Widget build(BuildContext context) {
    return MaterialApp(
      // MaterialApp adalah widget yang menyediakan struktur dasar untuk aplikasi Flutter
      // Mengatur judul aplikasi, banner debug, tema, dan rute awal
      title:
          'managekos', // Judul aplikasi yang akan ditampilkan di taskbar atau launcher
      debugShowCheckedModeBanner:
          false, // Menonaktifkan banner debug yang biasanya muncul di pojok kanan atas
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          useMaterial3:
              true), // Mengatur tema aplikasi dengan warna biru sebagai primary swatch dan menggunakan Material 3
      initialRoute: '/', // Rute awal aplikasi, yaitu halaman login
      // Mengatur rute untuk navigasi antar halaman
      routes: {
        // Daftar rute yang tersedia dalam aplikasi
        // Rute yang menghubungkan path dengan widget halaman
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/add': (context) => const AddPage(),
      },
      //home: Scaffold(body: Center(child: Text("helo"))),
    );
  }
}
