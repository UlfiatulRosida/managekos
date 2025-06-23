import 'package:flutter/material.dart';
import 'package:managekos/pages/login_page.dart';
import 'package:managekos/pages/home_page.dart';
import 'package:managekos/pages/add_page.dart';
import 'package:managekos/pages/edit_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhic2FzcXV5eHpldmNkcW1oeGZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2NzU3MjcsImV4cCI6MjA2MTI1MTcyN30.fDSLwsn0G2jUb82HhTEwsxYdng_3cDsdR7QxtRNPCOg';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://hbsasquyxzevcdqmhxfp.supabase.co', anonKey: supabaseKey);

  await Supabase.instance.client.auth.signOut();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Managekos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final session = Supabase.instance.client.auth.currentSession;
            if (session == null) {
              return const LoginPage();
            } else {
              return const HomePage();
            }
          }
        },
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/add': (context) => const AddPage(),
        '/edit': (context) => const EditPage(),
      },
    );
  }
}
