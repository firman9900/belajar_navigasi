// Jalankan project ini SENDIRI (tanpa menu):
//   flutter run -t lib/projects/p13_mini_toko.dart
// Atau lewat menu gabungan:  flutter run  (lib/main.dart)

import 'package:flutter/material.dart';
import '../common/app_common.dart';

// CATATAN: project ini memakai route.isFirst (pushAndRemoveUntil / popUntil)
// yang bergantung pada adanya halaman dasar di bawahnya. Karena itu saat
// dijalankan sendiri, project dibuka dari PintuProject (halaman dasar mini)
// sehingga perilakunya sama persis dengan saat dibuka dari menu gabungan.

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const PintuProject(judul: 'Project 13', tujuan: Project13Login()),
    ),
  );
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
