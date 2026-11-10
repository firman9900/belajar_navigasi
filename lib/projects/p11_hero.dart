// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p11_hero.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const Project11Hero(),
    ),
  );
}

// ============================================================================
// PROJECT 11 - HERO ANIMATION
// Konsep : widget yang punya TAG SAMA di dua halaman akan "terbang" mulus dari
//          halaman 1 ke halaman 2. Tag harus unik per item (kita pakai index).
// ============================================================================
const List<Color> _warnaHero = [
  Colors.red,
  Colors.orange,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.pink,
];

const List<IconData> _ikonHero = [
  Icons.favorite,
  Icons.star,
  Icons.eco,
  Icons.water_drop,
  Icons.music_note,
  Icons.cake,
];

class Project11Hero extends StatelessWidget {
  const Project11Hero({super.key});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '11 - Hero Animation',
      child: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(12),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(_warnaHero.length, (i) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => P11Detail(index: i)),
              );
            },
            child: Hero(
              tag: 'hero-$i', // TAG harus sama dengan di halaman detail
              child: Container(
                decoration: BoxDecoration(
                  color: _warnaHero[i],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_ikonHero[i], color: Colors.white, size: 40),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class P11Detail extends StatelessWidget {
  final int index;
  const P11Detail({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '11 - Detail',
      child: Center(
        child: Hero(
          tag: 'hero-$index', // sama dengan tag di halaman grid
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              color: _warnaHero[index],
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(_ikonHero[index], color: Colors.white, size: 130),
          ),
        ),
      ),
    );
  }
}
