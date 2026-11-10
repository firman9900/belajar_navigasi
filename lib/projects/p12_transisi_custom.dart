// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p12_transisi_custom.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Project12Transisi(),
    ),
  );
}

// ============================================================================
// PROJECT 12 - TRANSISI CUSTOM (PageRouteBuilder)
// Konsep : MaterialPageRoute memakai animasi standar. Dengan PageRouteBuilder
//          kita bebas membuat animasi sendiri lewat transitionsBuilder.
//          `animation` bernilai 0.0 -> 1.0 selama transisi berlangsung.
// ============================================================================
Route<void> buatRoute(String jenis, Widget tujuan) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) => tujuan,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (jenis) {
        case 'slide':
          // Geser masuk dari kanan (Offset(1,0)) ke posisi normal (Offset.zero)
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          );
        case 'fade':
          // Muncul perlahan (transparan -> jelas)
          return FadeTransition(opacity: animation, child: child);
        default:
          // Membesar dari kecil ke ukuran penuh
          return ScaleTransition(scale: animation, child: child);
      }
    },
  );
}

class Project12Transisi extends StatelessWidget {
  const Project12Transisi({super.key});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '12 - Transisi Custom',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final jenis in ['slide', 'fade', 'scale']) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, buatRoute(jenis, P12Tujuan(jenis: jenis)));
                },
                child: Text('Transisi ${jenis.toUpperCase()}'),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class P12Tujuan extends StatelessWidget {
  final String jenis;
  const P12Tujuan({super.key, required this.jenis});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '12 - ${jenis.toUpperCase()}',
      child: Center(
        child: Text(
          'Kamu tiba dengan transisi\n${jenis.toUpperCase()}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26),
        ),
      ),
    );
  }
}
