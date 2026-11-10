// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p06_login_home.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Project06Login(),
    ),
  );
}

// ============================================================================
// PROJECT 06 - LOGIN -> HOME (pushReplacement)
// Konsep : pushReplacement MENGGANTI halaman teratas (bukan menumpuk).
//          Setelah login, halaman login hilang dari tumpukan sehingga user
//          tidak bisa "kembali" ke form login.
//
//   Sebelum : [Menu][Login]
//   Sesudah : [Menu][Home]      <- Login digantikan Home
// ============================================================================
class Project06Login extends StatefulWidget {
  const Project06Login({super.key});

  @override
  State<Project06Login> createState() => _Project06LoginState();
}

class _Project06LoginState extends State<Project06Login> {
  final TextEditingController _user = TextEditingController();

  @override
  void dispose() {
    _user.dispose();
    super.dispose();
  }

  void _masuk() {
    final nama = _user.text.trim();
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username tidak boleh kosong')),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => P6Home(nama: nama)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '06 - Login',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: Colors.teal),
            const SizedBox(height: 16),
            TextField(
              controller: _user,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _masuk(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _masuk, child: const Text('Masuk')),
            ),
          ],
        ),
      ),
    );
  }
}

class P6Home extends StatelessWidget {
  final String nama;
  const P6Home({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '06 - Home',
      tampilkanBack: false, // sembunyikan panah kembali
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Selamat datang, $nama!',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Logout: ganti Home dengan Login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Project06Login()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
