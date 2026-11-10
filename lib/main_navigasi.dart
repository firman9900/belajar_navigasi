// ============================================================================
//  MATERI PERTEMUAN  - FLUTTER: NAVIGASI ANTAR HALAMAN
//  Mata Kuliah : Pemrograman Mobile
//  Isi         : 13 project dalam 1 file (menu utama -> pilih project)
// ============================================================================
//
//  KONSEP INTI (baca dulu sebelum lihat kode)
//  ------------------------------------------
//  1. ROUTE    = 1 halaman/layar dalam aplikasi.
//
//  2. NAVIGATOR = pengelola halaman. Cara kerjanya seperti TUMPUKAN PIRING
//     (stack): halaman baru diletakkan di ATAS, halaman yang terlihat user
//     selalu yang paling atas.
//
//         [ Halaman C ]  <- terlihat user (paling atas)
//         [ Halaman B ]
//         [ Halaman A ]  <- halaman awal (paling bawah)
//
//  3. Perintah dasar:
//       Navigator.push(context, route)      -> tumpuk halaman baru di atas
//       Navigator.pop(context)              -> buang halaman teratas (kembali)
//       Navigator.pop(context, hasil)       -> kembali SAMBIL membawa data
//       Navigator.pushNamed(context, '/x')  -> push berdasarkan NAMA route
//       Navigator.pushReplacement(...)      -> ganti halaman teratas
//       Navigator.pushAndRemoveUntil(...)   -> push + buang halaman di bawahnya
//       Navigator.popUntil(...)             -> kembali sampai syarat terpenuhi
//
//  4. Mengirim data MAJU  : lewat constructor halaman tujuan.
//     Mengirim data MUNDUR: lewat pop(context, hasil) + await di pemanggil.
//
//  5. Selain Navigator, ada widget navigasi bawaan di dalam 1 halaman:
//     NavigationBar (menu bawah), TabBar, dan Drawer (menu samping).
//
//  Cara menjalankan:
//     - flutter create belajar_navigasi
//     - Ganti isi lib/main.dart dengan file ini
//     - flutter run
// ============================================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ----------------------------------------------------------------------------
// MyApp : root aplikasi.
// Properti `routes` berisi daftar NAMA route -> dipakai Project 04 & 05.
// ----------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar Navigasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // Halaman pertama yang tampil (dasar tumpukan)
      home: const DaftarProject(),
      // Daftar route bernama. Format:  'nama-route': (context) => Halaman()
      // Catatan: jangan buat route '/' di sini karena sudah ada `home`.
      routes: {
        '/p4-profil': (context) => const P4Profil(),
        '/p4-pengaturan': (context) => const P4Pengaturan(),
        '/p5-detail': (context) => const P5Detail(),
      },
    );
  }
}

// ----------------------------------------------------------------------------
// Model 1 baris menu project
// ----------------------------------------------------------------------------
class ItemProject {
  final String judul;
  final String konsep;
  final Widget halaman;

  ItemProject(this.judul, this.konsep, this.halaman);
}

// ----------------------------------------------------------------------------
// DaftarProject : menu berisi 13 project (ini adalah halaman PALING BAWAH di
// tumpukan Navigator).
// ----------------------------------------------------------------------------
class DaftarProject extends StatelessWidget {
  const DaftarProject({super.key});

  @override
  Widget build(BuildContext context) {
    final daftar = <ItemProject>[
      ItemProject('01 - Navigator Dasar', 'push & pop', const Project01Dasar()),
      ItemProject('02 - Kirim Data', 'data lewat constructor', const Project02KirimData()),
      ItemProject('03 - Terima Hasil', 'pop(hasil) + await', const Project03Hasil()),
      ItemProject('04 - Named Routes', 'pushNamed', const Project04NamedRoute()),
      ItemProject('05 - Named + Arguments', 'arguments & ModalRoute', const Project05Arguments()),
      ItemProject('06 - Login -> Home', 'pushReplacement', const Project06Login()),
      ItemProject('07 - Tumpukan Halaman', 'popUntil, pushAndRemoveUntil', const Project07Tumpukan(level: 1)),
      ItemProject('08 - Bottom Navigation', 'NavigationBar + IndexedStack', const Project08BottomNav()),
      ItemProject('09 - TabBar', 'TabBar & TabBarView', const Project09TabBar()),
      ItemProject('10 - Drawer', 'menu samping', const Project10Drawer()),
      ItemProject('11 - Hero Animation', 'transisi antar halaman', const Project11Hero()),
      ItemProject('12 - Transisi Custom', 'PageRouteBuilder', const Project12Transisi()),
      ItemProject('13 - Mini Toko', 'GABUNGAN semua konsep', const Project13Login()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigasi Flutter'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: daftar.length,
        itemBuilder: (context, i) {
          final p = daftar[i];
          return ListTile(
            leading: CircleAvatar(child: Text('${i + 1}')),
            title: Text(p.judul),
            subtitle: Text(p.konsep),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // PUSH: letakkan halaman project di atas tumpukan.
              // MaterialPageRoute = "bungkus" halaman dengan animasi
              // perpindahan standar Android/iOS.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => p.halaman),
              );
            },
          );
        },
      ),
    );
  }
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

// ============================================================================
// PROJECT 01 - NAVIGATOR DASAR (push & pop)
// Konsep : push = buka halaman baru, pop = tutup halaman teratas.
// Catatan: tombol panah "kembali" di AppBar otomatis memanggil pop().
// ============================================================================
class Project01Dasar extends StatelessWidget {
  const Project01Dasar({super.key});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '01 - Halaman A',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.looks_one, size: 100, color: Colors.teal),
            const Text('Ini HALAMAN A', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const P1HalamanB()),
                );
              },
              child: const Text('Buka Halaman B'),
            ),
          ],
        ),
      ),
    );
  }
}

class P1HalamanB extends StatelessWidget {
  const P1HalamanB({super.key});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '01 - Halaman B',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.looks_two, size: 100, color: Colors.orange),
            const Text('Ini HALAMAN B', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // POP: buang halaman B -> kembali ke halaman A
                Navigator.pop(context);
              },
              child: const Text('Kembali ke A'),
            ),
          ],
        ),
      ),
    );
  }
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
            const Icon(Icons.person, size: 90, color: Colors.teal),
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

// ============================================================================
// PROJECT 04 - NAMED ROUTES
// Konsep : route diberi NAMA di MaterialApp(routes: {...}) lalu dipanggil
//          dengan pushNamed. Keuntungan: tidak perlu menulis MaterialPageRoute
//          berulang & nama route terpusat di 1 tempat.
// ============================================================================
class Project04NamedRoute extends StatelessWidget {
  const Project04NamedRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '04 - Named Routes',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Ke Profil'),
              // Cukup tulis NAMA route yang didaftarkan di main
              onPressed: () => Navigator.pushNamed(context, '/p4-profil'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Ke Pengaturan'),
              onPressed: () => Navigator.pushNamed(context, '/p4-pengaturan'),
            ),
          ],
        ),
      ),
    );
  }
}

class P4Profil extends StatelessWidget {
  const P4Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Halaman(
      judul: '04 - Profil',
      child: Center(child: Text('Halaman PROFIL', style: TextStyle(fontSize: 26))),
    );
  }
}

class P4Pengaturan extends StatelessWidget {
  const P4Pengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    return const Halaman(
      judul: '04 - Pengaturan',
      child: Center(child: Text('Halaman PENGATURAN', style: TextStyle(fontSize: 26))),
    );
  }
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

// ============================================================================
// PROJECT 06 - LOGIN -> HOME (pushReplacement)
// Konsep : pushReplacement MENGGANTI halaman teratas (bukan menumpuk).
//          Setelah login, halaman login hilang dari tumpukan sehingga user
//          tidak bisa "kembali" ke form login.
//
//   Sebelum : [Menu][Login]
//   Sesudah : [Menu][Home]      <- Login digantikan Home
// ============================================================================
class Project06Login extends StatefulWidget {
  const Project06Login({super.key});

  @override
  State<Project06Login> createState() => _Project06LoginState();
}

class _Project06LoginState extends State<Project06Login> {
  final TextEditingController _user = TextEditingController();

  @override
  void dispose() {
    _user.dispose();
    super.dispose();
  }

  void _masuk() {
    final nama = _user.text.trim();
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username tidak boleh kosong')),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => P6Home(nama: nama)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '06 - Login',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: Colors.teal),
            const SizedBox(height: 16),
            TextField(
              controller: _user,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _masuk(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _masuk, child: const Text('Masuk')),
            ),
          ],
        ),
      ),
    );
  }
}

class P6Home extends StatelessWidget {
  final String nama;
  const P6Home({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '06 - Home',
      tampilkanBack: false, // sembunyikan panah kembali
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Selamat datang, $nama!',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Logout: ganti Home dengan Login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Project06Login()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
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

// ============================================================================
// PROJECT 13 - MINI TOKO (GABUNGAN)
// Alur lengkap:
//   Login --pushReplacement--> Beranda (NavigationBar: Produk | Profil)
//   Produk --push + Hero + kirim data--> Detail
//   Detail --pop(jumlah)--> Beranda (keranjang bertambah, tampil SnackBar)
//   Profil: Logout --pushAndRemoveUntil--> Login (tumpukan dibersihkan)
// ============================================================================
class Produk13 {
  final String nama;
  final int harga;
  final IconData ikon;
  final Color warna;

  const Produk13(this.nama, this.harga, this.ikon, this.warna);
}

const List<Produk13> _daftarProduk13 = [
  Produk13('Kopi Susu', 18000, Icons.coffee, Colors.brown),
  Produk13('Roti Bakar', 10000, Icons.bakery_dining, Colors.orange),
  Produk13('Es Teh', 5000, Icons.local_drink, Colors.green),
  Produk13('Nasi Goreng', 15000, Icons.rice_bowl, Colors.red),
];

// ---- Halaman 1: Login ------------------------------------------------------
class Project13Login extends StatefulWidget {
  const Project13Login({super.key});

  @override
  State<Project13Login> createState() => _Project13LoginState();
}

class _Project13LoginState extends State<Project13Login> {
  final TextEditingController _nama = TextEditingController();

  @override
  void dispose() {
    _nama.dispose();
    super.dispose();
  }

  void _masuk() {
    final nama = _nama.text.trim();
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi nama dulu ya')),
      );
      return;
    }
    // pushReplacement: login diganti beranda
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => P13Beranda(nama: nama)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Halaman(
      judul: '13 - Mini Toko',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.storefront, size: 90, color: Colors.teal),
            const SizedBox(height: 16),
            TextField(
              controller: _nama,
              decoration: const InputDecoration(
                labelText: 'Nama kamu',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _masuk(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _masuk, child: const Text('Masuk')),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Halaman 2: Beranda (bottom navigation + daftar produk) ----------------
class P13Beranda extends StatefulWidget {
  final String nama;
  const P13Beranda({super.key, required this.nama});

  @override
  State<P13Beranda> createState() => _P13BerandaState();
}

class _P13BerandaState extends State<P13Beranda> {
  int _tab = 0;
  int _keranjang = 0; // total item yang sudah dibeli

  Future<void> _bukaDetail(int i) async {
    // Buka detail, TUNGGU hasilnya (jumlah yang dibeli)
    final jumlah = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (context) => P13Detail(index: i)),
    );

    if (!mounted) return;

    // jumlah null = user menekan back tanpa membeli
    if (jumlah != null && jumlah > 0) {
      setState(() {
        _keranjang += jumlah;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$jumlah x ${_daftarProduk13[i].nama} masuk keranjang')),
      );
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Project13Login()),
      (route) => route.isFirst, // sisakan hanya halaman menu di bawahnya
    );
  }

  Widget _tabProduk() {
    return ListView.builder(
      itemCount: _daftarProduk13.length,
      itemBuilder: (context, i) {
        final p = _daftarProduk13[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Hero(
              tag: 'produk-$i',
              child: CircleAvatar(
                backgroundColor: p.warna,
                child: Icon(p.ikon, color: Colors.white),
              ),
            ),
            title: Text(p.nama),
            subtitle: Text(rupiah(p.harga)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _bukaDetail(i),
          ),
        );
      },
    );
  }

  Widget _tabProfil() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 12),
          Text(widget.nama,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Item di keranjang: $_keranjang'),
          const SizedBox(height: 20),
          OutlinedButton(onPressed: _logout, child: const Text('Logout')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hai, ${widget.nama}'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Badge(
            isLabelVisible: _keranjang > 0,
            label: Text('$_keranjang'),
            child: const Icon(Icons.shopping_cart),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _tab == 0 ? _tabProduk() : _tabProfil(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) {
          setState(() {
            _tab = i;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront), label: 'Produk'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// ---- Halaman 3: Detail produk ----------------------------------------------
class P13Detail extends StatefulWidget {
  final int index; // produk ke berapa (DATA DIKIRIM lewat constructor)
  const P13Detail({super.key, required this.index});

  @override
  State<P13Detail> createState() => _P13DetailState();
}

class _P13DetailState extends State<P13Detail> {
  int _jumlah = 1;

  @override
  Widget build(BuildContext context) {
    final p = _daftarProduk13[widget.index];
    return Halaman(
      judul: p.nama,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'produk-${widget.index}', // sama dengan tag di daftar
              child: CircleAvatar(
                radius: 70,
                backgroundColor: p.warna,
                child: Icon(p.ikon, color: Colors.white, size: 70),
              ),
            ),
            const SizedBox(height: 16),
            Text(p.nama, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(rupiah(p.harga), style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      if (_jumlah > 1) _jumlah--;
                    });
                  },
                ),
                Text('$_jumlah', style: const TextStyle(fontSize: 24)),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.teal),
                  onPressed: () {
                    setState(() {
                      _jumlah++;
                    });
                  },
                ),
              ],
            ),
            Text('Total: ${rupiah(p.harga * _jumlah)}'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Tambah ke Keranjang'),
              onPressed: () {
                // KEMBALI SAMBIL MEMBAWA HASIL (jumlah yang dibeli)
                Navigator.pop(context, _jumlah);
              },
            ),
          ],
        ),
      ),
    );
  }
}
