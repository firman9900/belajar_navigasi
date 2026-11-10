// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p03_terima_hasil.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Project03Hasil(),
    ),
  );
}

// ============================================================================
// PROJECT 03 - TERIMA HASIL DARI HALAMAN LAIN
// Konsep : kebalikan Project 02. Halaman kedua mengembalikan data lewat
//          Navigator.pop(context, hasil). Halaman pertama menangkapnya dengan
//          `await Navigator.push(...)`.
// ============================================================================
class Project03Hasil extends StatefulWidget {
  const Project03Hasil({super.key});

  @override
  State<Project03Hasil> createState() => _Project03HasilState();
}

class _Project03HasilState extends State<Project03Hasil> {
  String _pilihan = 'Belum memilih';

  Future<void> _bukaPilihan() async {
    // await = TUNGGU sampai halaman P3Pilih ditutup (pop).
    // <String> = tipe data hasil yang diharapkan.
    final hasil = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const P3Pilih()),
    );

    // Setelah await, pastikan halaman ini masih ada di layar.
    if (!mounted) return;

    // hasil bisa null jika user menekan tombol back tanpa memilih.
    if (hasil != null) {
      setState(() {
        _pilihan = hasil;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '03 - Terima Hasil',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Buah favoritmu:', style: TextStyle(fontSize: 18)),
            Text(
              _pilihan,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bukaPilihan,
              child: const Text('Pilih Buah'),
            ),
          ],
        ),
      ),
    );
  }
}

class P3Pilih extends StatelessWidget {
  const P3Pilih({super.key});

  @override
  Widget build(BuildContext context) {
    final buah = ['Apel', 'Mangga', 'Jeruk', 'Pisang', 'Semangka'];
    return Halaman(
      judul: '03 - Pilih Buah',
      child: ListView.builder(
        itemCount: buah.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: const Icon(Icons.apple),
            title: Text(buah[i]),
            onTap: () {
              // KEMBALI SAMBIL MEMBAWA DATA
              Navigator.pop(context, buah[i]);
            },
          );
        },
      ),
    );
  }
}
