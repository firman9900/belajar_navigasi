// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p08_bottom_nav.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Project08BottomNav(),
    ),
  );
}

// ============================================================================
// PROJECT 08 - BOTTOM NAVIGATION (NavigationBar)
// Konsep : berpindah antar bagian aplikasi di DALAM 1 halaman (bukan push).
//          State _index menentukan tab aktif.
//          IndexedStack = semua tab dibuat sekaligus & state-nya DIINGAT.
//          (Buktikan: ubah angka di tab Hitung, pindah tab, lalu balik lagi.)
// ============================================================================
class Project08BottomNav extends StatefulWidget {
  const Project08BottomNav({super.key});

  @override
  State<Project08BottomNav> createState() => _Project08BottomNavState();
}

class _Project08BottomNavState extends State<Project08BottomNav> {
  int _index = 0;

  final List<Widget> _tab = const [
    P8Beranda(),
    P8Hitung(),
    P8Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('08 - Bottom Navigation'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(index: _index, children: _tab),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          setState(() {
            _index = i;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Hitung',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class P8Beranda extends StatelessWidget {
  const P8Beranda({super.key});
  @override
  Widget build(BuildContext context) => const Center(
        child: Text('TAB BERANDA', style: TextStyle(fontSize: 26)),
      );
}

class P8Profil extends StatelessWidget {
  const P8Profil({super.key});
  @override
  Widget build(BuildContext context) => const Center(
        child: Text('TAB PROFIL', style: TextStyle(fontSize: 26)),
      );
}

// Tab yang punya state sendiri (counter) untuk membuktikan IndexedStack
class P8Hitung extends StatefulWidget {
  const P8Hitung({super.key});

  @override
  State<P8Hitung> createState() => _P8HitungState();
}

class _P8HitungState extends State<P8Hitung> {
  int _angka = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$_angka', style: const TextStyle(fontSize: 64)),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _angka++;
              });
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
