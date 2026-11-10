// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p02_kirim_data.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Project02KirimData(),
    ),
  );
}

// ============================================================================
// PROJECT 02 - KIRIM DATA KE HALAMAN BERIKUTNYA
// Konsep : data dikirim lewat CONSTRUCTOR halaman tujuan.
// Alur   : isi form -> klik kirim -> halaman tujuan menerima nama & jurusan.
// ============================================================================
class Project02KirimData extends StatefulWidget {
  const Project02KirimData({super.key});

  @override
  State<Project02KirimData> createState() => _Project02KirimDataState();
}

class _Project02KirimDataState extends State<Project02KirimData> {
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _jurusan = TextEditingController();

  @override
  void dispose() {
    _nama.dispose();
    _jurusan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '02 - Kirim Data',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nama,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jurusan,
              decoration: const InputDecoration(
                labelText: 'Jurusan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // DATA DIKIRIM DI SINI (nama & jurusan masuk constructor)
                    builder: (context) => P2Sapa(
                      nama: _nama.text,
                      jurusan: _jurusan.text,
                    ),
                  ),
                );
              },
              child: const Text('Kirim ke Halaman Berikutnya'),
            ),
          ],
        ),
      ),
    );
  }
}

class P2Sapa extends StatelessWidget {
  // Data yang DITERIMA disimpan sebagai field final
  final String nama;
  final String jurusan;

  const P2Sapa({super.key, required this.nama, required this.jurusan});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '02 - Halaman Tujuan',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 90, color: Color.fromARGB(255, 96, 3, 3)),
            Text(
              nama.isEmpty ? '(tanpa nama)' : 'Halo, $nama!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              jurusan.isEmpty ? '(jurusan kosong)' : 'Jurusan $jurusan',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
