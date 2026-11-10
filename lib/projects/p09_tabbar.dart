// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p09_tabbar.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Project09TabBar(),
    ),
  );
}

// ============================================================================
// PROJECT 09 - TABBAR
// Konsep : tab di bagian ATAS yang bisa digeser kiri-kanan.
//   DefaultTabController -> pengatur (jumlah tab = length)
//   TabBar               -> deretan judul tab (di AppBar.bottom)
//   TabBarView           -> isi tiap tab (urutannya HARUS sama dengan TabBar)
// ============================================================================
class Project09TabBar extends StatelessWidget {
  const Project09TabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('09 - TabBar'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.chat), text: 'Chat'),
              Tab(icon: Icon(Icons.update), text: 'Status'),
              Tab(icon: Icon(Icons.call), text: 'Panggilan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Isi tab CHAT', style: TextStyle(fontSize: 24))),
            Center(child: Text('Isi tab STATUS', style: TextStyle(fontSize: 24))),
            Center(child: Text('Isi tab PANGGILAN', style: TextStyle(fontSize: 24))),
          ],
        ),
      ),
    );
  }
}
