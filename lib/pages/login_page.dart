import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // Untuk mendefinisikan widget login

  @override
  State<LoginPage> createState() =>
      _LoginPageState(); // Untuk membuat state dari widget login
}

class _LoginPageState extends State<LoginPage> {
  // Untuk mendefinisikan state dari widget login
  final SupabaseClient supabase =
      Supabase.instance.client; // Inisialisasi klien Supabase untuk otentikasi
  final _formKey = GlobalKey<FormState>(); // Untuk mengelola status form login

  final _emailController = TextEditingController();
  final _passwordController =
      TextEditingController(); // Kontroler untuk input email dan password

  bool _obscurePassword =
      true; // Variabel boolean untuk menyembunyikan atau menampilkan password
  bool _isLoading =
      false; // untuk menandakan apakah proses login sedang berlangsung

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return; // Validasi form jika tidak valid, proses diberhentikan
    }

    setState(() => _isLoading = true); // Menampilkan loading

    final email = _emailController.text.trim();
    final password = _passwordController
        .text; // Mengambil nilai email dan password dari kontroler

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      ); // Mengirim permintaan login ke Supabase dengan email dan password

      if (response.session == null) {
        throw 'Login gagal, periksa kembali';
      } // Memeriksa apakah sesi berhasil dibuat

      if (!mounted) {
        return; // Memastikan widget masih terpasang sebelum melakukan navigasi
      }
      Navigator.of(context).pushNamedAndRemoveUntil('/home',
          (route) => false); // Jika login berhasil, navigasi ke halaman home
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    } finally {
      setState(() => _isLoading =
          false); // Mengubah status loading menjadi false setelah proses login selesai
    }
  }

  @override
  void dispose() {
    //
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  } // Untuk membersihkan kontroler saat widget dihapus dari pohon widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0), // memberi jarak
          child: Form(
            key: _formKey, // untuk validasi
            child: ListView(
              // agar bisa scroll
              shrinkWrap: true, // untuk menghindari overflow
              children: [
                const Text(
                  "Login Admin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 16), //spasi vertikal 16 pixel
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    } else if (!value.contains('@')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  }, // Validasi input email
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }
                    return null;
                  }, // Validasi input password
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                ), // Tombol untuk login
              ],
            ),
          ),
        ),
      ),
    );
  }
}
