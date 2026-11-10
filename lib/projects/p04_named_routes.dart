// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p04_named_routes.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routes: p4Routes,
      home: const Project04NamedRoute(),
    ),
  );
}

// ============================================================================
// PROJECT 04 - NAMED ROUTES
// Konsep : route diberi NAMA di MaterialApp(routes: {...}) lalu dipanggil
//          dengan pushNamed. Keuntungan: tidak perlu menulis MaterialPageRoute
//          berulang & nama route terpusat di 1 tempat.
// ============================================================================
class Project04NamedRoute extends StatelessWidget {
  const Project04NamedRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '04 - Named Routes',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Ke Profil'),
              // Cukup tulis NAMA route yang didaftarkan di main
              onPressed: () => Navigator.pushNamed(context, '/p4-profil'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Ke Pengaturan'),
              onPressed: () => Navigator.pushNamed(context, '/p4-pengaturan'),
            ),
          ],
        ),
      ),
    );
  }
}

class P4Profil extends StatelessWidget {
  const P4Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Halaman(
      judul: '04 - Profil',
      child: Center(child: Text('Halaman PROFIL', style: TextStyle(fontSize: 26))),
    );
  }
}

class P4Pengaturan extends StatelessWidget {
  const P4Pengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    return const Halaman(
      judul: '04 - Pengaturan',
      child: Center(child: Text('Halaman PENGATURAN', style: TextStyle(fontSize: 26))),
    );
  }
}

// Daftar route bernama untuk Project 04.
// Didaftarkan ke MaterialApp(routes: ...) -- baik di main() file ini
// maupun di main.dart (menu gabungan).
final Map<String, WidgetBuilder> p4Routes = {
  '/p4-profil': (context) => const P4Profil(),
  '/p4-pengaturan': (context) => const P4Pengaturan(),
};
