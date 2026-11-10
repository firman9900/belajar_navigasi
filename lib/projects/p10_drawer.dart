// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p10_drawer.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Project10Drawer(),
    ),
  );
}

// ============================================================================
// PROJECT 10 - DRAWER
// Konsep : menu geser dari kiri (atau tekan ikon hamburger).
//          Setelah item dipilih, drawer harus DITUTUP manual dengan
//          Navigator.pop(context) karena drawer juga sebuah route.
// ============================================================================
class Project10Drawer extends StatefulWidget {
  const Project10Drawer({super.key});

  @override
  State<Project10Drawer> createState() => _Project10DrawerState();
}

class _Project10DrawerState extends State<Project10Drawer> {
  int _menu = 0;
  final List<String> _judul = ['Beranda', 'Pesan', 'Pengaturan'];
  final List<IconData> _ikon = [Icons.home, Icons.message, Icons.settings];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('10 - ${_judul[_menu]}'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Mahasiswa'),
              accountEmail: Text('mahasiswa@kampus.ac.id'),
              currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
              decoration: BoxDecoration(color: Colors.teal),
            ),
            // List.generate membuat 3 ListTile dari data di atas
            ...List.generate(_judul.length, (i) {
              return ListTile(
                leading: Icon(_ikon[i]),
                title: Text(_judul[i]),
                selected: _menu == i, // item aktif disorot
                onTap: () {
                  setState(() {
                    _menu = i;
                  });
                  Navigator.pop(context); // tutup drawer
                },
              );
            }),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_ikon[_menu], size: 90, color: Colors.teal),
            Text('Halaman ${_judul[_menu]}', style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 8),
            const Text('Geser dari kiri atau tekan ikon hamburger'),
          ],
        ),
      ),
    );
  }
}
