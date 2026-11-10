// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p01_navigator_dasar.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Project01Dasar(),
    ),
  );
}

// ============================================================================
// PROJECT 01 - NAVIGATOR DASAR (push & pop)
// Konsep : push = buka halaman baru, pop = tutup halaman teratas.
// Catatan: tombol panah "kembali" di AppBar otomatis memanggil pop().
// ============================================================================
class Project01Dasar extends StatelessWidget {
  const Project01Dasar({super.key});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '01 - Halaman A',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.looks_one, size: 100, color: Color.fromARGB(255, 255, 5, 5)),
            const Text('Ini HALAMAN A', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const P1HalamanB()),
                );
              },
              child: const Text('Buka Halaman B'),
            ),
          ],
        ),
      ),
    );
  }
}

class P1HalamanB extends StatelessWidget {
  const P1HalamanB({super.key});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '01 - Halaman B',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.looks_two, size: 100, color: Colors.orange),
            const Text('Ini HALAMAN B', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // POP: buang halaman B -> kembali ke halaman A
                Navigator.pop(context);
              },
              child: const Text('Kembali ke A'),
            ),
          ],
        ),
      ),
    );
  }
}
