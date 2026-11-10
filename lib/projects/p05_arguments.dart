// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p05_arguments.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routes: p5Routes,
      home: const Project05Arguments(),
    ),
  );
}

// ============================================================================
// PROJECT 05 - NAMED ROUTE + ARGUMENTS
// Konsep : pushNamed bisa membawa data lewat parameter `arguments`.
//          Di halaman tujuan, data dibaca dengan
//          ModalRoute.of(context)!.settings.arguments
// ============================================================================
class Project05Arguments extends StatelessWidget {
  const Project05Arguments({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = ['Nasi Goreng', 'Mie Ayam', 'Bakso', 'Sate Ayam'];
    return Halaman(
      judul: '05 - Named + Arguments',
      child: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: const Icon(Icons.restaurant),
            title: Text(menu[i]),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/p5-detail',
                arguments: menu[i], // DATA DIKIRIM LEWAT arguments
              );
            },
          );
        },
      ),
    );
  }
}

class P5Detail extends StatelessWidget {
  const P5Detail({super.key});

  @override
  Widget build(BuildContext context) {
    // Baca data yang dikirim. `as String` = ubah tipe Object? menjadi String.
    final nama = ModalRoute.of(context)!.settings.arguments as String;

    return Halaman(
      judul: '05 - Detail',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restaurant_menu, size: 90, color: Colors.teal),
            Text(nama, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// Daftar route bernama untuk Project 05.
final Map<String, WidgetBuilder> p5Routes = {
  '/p5-detail': (context) => const P5Detail(),
};
