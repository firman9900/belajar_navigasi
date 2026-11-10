// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p07_tumpukan_halaman.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

// CATATAN: project ini memakai route.isFirst (pushAndRemoveUntil / popUntil)
// yang bergantung pada adanya halaman dasar di bawahnya. Karena itu saat
// dijalankan sendiri, project dibuka dari PintuProject (halaman dasar mini)
// sehingga perilakunya sama persis dengan saat dibuka dari menu gabungan.

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const PintuProject(judul: 'Project 07', tujuan: Project07Tumpukan(level: 1)),
    ),
  );
}

// ============================================================================
// PROJECT 07 - TUMPUKAN HALAMAN (popUntil & pushAndRemoveUntil)
// Konsep : melihat Navigator sebagai stack. Buka beberapa halaman bertingkat,
//          lalu coba 3 cara keluar:
//            a) pop            -> mundur 1 langkah
//            b) popUntil       -> mundur sampai halaman PALING AWAL (menu)
//            c) pushAndRemoveUntil -> buang semua halaman di antara, lalu buka
//                                     halaman baru
// ============================================================================
class Project07Tumpukan extends StatelessWidget {
  final int level; // urutan halaman ke berapa
  const Project07Tumpukan({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '07 - Langkah $level',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Langkah ke-$level',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('(ada $level halaman project di tumpukan)'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Project07Tumpukan(level: level + 1),
                  ),
                );
              },
              child: const Text('Langkah Berikutnya (push)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Mundur terus sampai ketemu route PERTAMA (halaman menu)
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Kembali ke Menu (popUntil)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Buka P7Selesai, lalu buang SEMUA halaman kecuali yang pertama
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const P7Selesai()),
                  (route) => route.isFirst, // syarat: sisakan route pertama
                );
              },
              child: const Text('Selesai (pushAndRemoveUntil)'),
            ),
          ],
        ),
      ),
    );
  }
}

class P7Selesai extends StatelessWidget {
  const P7Selesai({super.key});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '07 - Selesai',
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Semua halaman langkah sudah dibuang dari tumpukan.\n'
            'Coba tekan tombol kembali: langsung ke menu!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
