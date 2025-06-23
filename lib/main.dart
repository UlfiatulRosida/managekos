import 'package:flutter/material.dart'; // Untuk membangun UI dengan Komponen flutter
import 'package:managekos/pages/login_page.dart';
import 'package:managekos/pages/home_page.dart';
import 'package:managekos/pages/add_page.dart';
import 'package:managekos/pages/edit_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Untuk Mengakses supabase dan berpindah antar halaman

const String
    supabaseKey = //Untuk menyimpan kunci API Supabase agar bisa digunakan autentikasi
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhic2FzcXV5eHpldmNkcW1oeGZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2NzU3MjcsImV4cCI6MjA2MTI1MTcyN30.fDSLwsn0G2jUb82HhTEwsxYdng_3cDsdR7QxtRNPCOg';
Future<void> main() async {
  // Untuk menjalankan aplikasi Flutter berjalan secara asinkron
  WidgetsFlutterBinding
      .ensureInitialized(); // Untuk inisialisasi Flutter sebelum menjalankan plugin

  await Supabase.initialize(
      //Menghubungkan aplikasi ke Supabase dengan URL dan API key
      url: 'https://hbsasquyxzevcdqmhxfp.supabase.co',
      anonKey: supabaseKey);

  await Supabase.instance.client.auth
      .signOut(); // Untuk logout otomatis saat aplikasi dibuka

  runApp(
      const MainApp()); // Menjalankan aplikasi dengan MainApp sebagai root widget
}

class MainApp extends StatelessWidget {
  // Untuk mendefinisikan widget utama aplikasi
  const MainApp({super.key}); // Konstruktor MainApp untuk menerima key

  @override
  Widget build(BuildContext context) {
    // Untuk membangun UI aplikasi
    return MaterialApp(
      // Untuk membuat aplikasi Material Design
      title: 'Managekos', // Judul aplikasi yang akan ditampilkan di taskbar
      debugShowCheckedModeBanner:
          false, // Untuk menghilangkan banner debug di pojok kanan atas
      theme: ThemeData(
          primarySwatch: Colors.red,
          useMaterial3:
              true), // Untuk mengatur tema aplikasi dengan warna utama merah dan menggunakan Material 3
      home: StreamBuilder<AuthState>(
        // Untuk membangun UI berdasarkan perubahan status autentikasi
        stream: Supabase.instance.client.auth
            .onAuthStateChange, //Stream auth Supabase untuk memperbarui UI saat login/logout
        builder: (context, snapshot) {
          // Untuk membangun widget berdasarkan data terbaru dari stream
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Memeriksa apakah stream masih dalam proses loading
            return const Scaffold(
              // Menampilkan indikator loading saat stream masih proses
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // jika stream sudah selssai dan tidak dalam proses loading
            final session = Supabase.instance.client.auth
                .currentSession; // Mengambil sesi login pengguna dari Supabase
            if (session == null) {
              //Memeriksa jika pengguna belum login (sesi kosong)
              return const LoginPage(); //Jika tidak ada sesi, tampilkan halaman LoginPage
            } else {
              // Jika sesi ada, berarti pengguna sudah login
              // Jika pengguna sudah login, arahkan ke halaman HomePage
              return const HomePage();
            }
          }
        },
      ),
      initialRoute: '/', // Untuk menentukan rute awal aplikasi
      routes: {
        // Untuk mendefinisikan rute-rute yang tersedia dalam aplikasi
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/add': (context) => const AddPage(),
        '/edit': (context) => const EditPage(),
      },
    );
  }
}
