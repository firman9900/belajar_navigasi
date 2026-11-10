// ============================================================================
//  KOMPONEN BERSAMA (dipakai semua project)
//   - buildAppTheme() : tema aplikasi (warna teal, Material 3)
//   - Halaman         : kerangka halaman dengan AppBar
//   - rupiah()        : format angka menjadi "Rp 15.000"
// ============================================================================

import 'package:flutter/material.dart';

// Tema yang sama dipakai di menu gabungan (main.dart) dan di setiap project
// yang dijalankan sendiri-sendiri.
ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    useMaterial3: true,
  );
}

// ----------------------------------------------------------------------------
// Halaman : kerangka halaman dengan AppBar (dipakai agar kode tidak berulang)
// ----------------------------------------------------------------------------
class Halaman extends StatelessWidget {
  final String judul;
  final Widget child;
  final bool tampilkanBack; // false = sembunyikan tombol panah kembali

  const Halaman({
    super.key,
    required this.judul,
    required this.child,
    this.tampilkanBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: tampilkanBack,
      ),
      body: child,
    );
  }
}

// Fungsi bantu: 15000 -> "Rp 15.000"
String rupiah(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}


// ----------------------------------------------------------------------------
// PintuProject : halaman dasar mini untuk menjalankan project secara terpisah.
// Setelah frame pertama, ia langsung membuka project tujuan di atasnya
// sehingga tumpukan Navigator = [PintuProject, Project], mirip saat dibuka
// dari menu gabungan. Dipakai oleh Project 07 dan Project 13.
// ----------------------------------------------------------------------------
class PintuProject extends StatefulWidget {
  final String judul;
  final Widget tujuan;

  const PintuProject({super.key, required this.judul, required this.tujuan});

  @override
  State<PintuProject> createState() => _PintuProjectState();
}

class _PintuProjectState extends State<PintuProject> {
  void _buka() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget.tujuan),
    );
  }

  @override
  void initState() {
    super.initState();
    // Tunggu frame pertama selesai, baru buka project.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _buka();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: 'Halaman Dasar',
      child: Center(
        child: ElevatedButton(
          onPressed: _buka,
          child: Text('Buka ${widget.judul}'),
        ),
      ),
    );
  }
}
