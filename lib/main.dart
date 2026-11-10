// Pertemuan 5 - Form tambah data mahasiswa dengan validasi (Tugas 4)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Akademik Mahasiswa',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      home: const DashboardPage(),
    );
  }
}

const List<Map<String, String>> daftarMahasiswa = [
  {'nama': 'Rina Amelia', 'nim': '2023001', 'prodi': 'Sistem Informasi', 'semester': '5', 'email': 'rina@contoh.ac.id'},
  {'nama': 'Budi Santoso', 'nim': '2023002', 'prodi': 'Sistem Informasi', 'semester': '5', 'email': 'budi@contoh.ac.id'},
  {'nama': 'Siti Rahma', 'nim': '2023003', 'prodi': 'Sistem Informasi', 'semester': '3', 'email': 'siti@contoh.ac.id'},
];

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Akademik'), backgroundColor: warna.primaryContainer),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TambahMahasiswaPage())),
        icon: const Icon(Icons.person_add), label: const Text('Tambah'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
        children: [
          Card(child: ListTile(
            leading: const Icon(Icons.person), title: const Text('Profil Saya'), subtitle: const Text('Identitas dan keahlian'),
            trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilPage())),
          )),
          const SizedBox(height: 16),
          const Text('Daftar Mahasiswa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final mhs in daftarMahasiswa)
            Card(child: ListTile(
              leading: CircleAvatar(child: Text(mhs['nama']![0])),
              title: Text(mhs['nama']!), subtitle: Text('NIM ${mhs['nim']}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailMahasiswaPage(mahasiswa: mhs))),
            )),
        ],
      ),
    );
  }
}

String? validasiNama(String? val) {
  final t = val?.trim() ?? '';
  if (t.isEmpty) return 'Nama wajib diisi';
  if (t.length < 3) return 'Nama minimal 3 huruf';
  return null;
}
String? validasiNim(String? val) {
  final t = val?.trim() ?? '';
  if (t.isEmpty) return 'NIM wajib diisi';
  if (!RegExp(r'^[0-9]+$').hasMatch(t)) return 'NIM hanya boleh berisi angka';
  if (t.length < 7) return 'NIM minimal 7 digit';
  return null;
}
String? validasiEmail(String? val) {
  final t = val?.trim() ?? '';
  if (t.isEmpty) return 'Email wajib diisi';
  if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(t)) return 'Format email tidak valid (contoh: nama@kampus.ac.id)';
  return null;
}
String? validasiSemester(String? val) {
  final t = val?.trim() ?? '';
  if (t.isEmpty) return 'Semester wajib diisi';
  final a = int.tryParse(t);
  if (a == null) return 'Semester harus berupa angka';
  if (a < 1 || a > 14) return 'Semester harus antara 1 dan 14';
  return null;
}

class TambahMahasiswaPage extends StatefulWidget {
  const TambahMahasiswaPage({super.key});
  @override
  State<TambahMahasiswaPage> createState() => _TambahMahasiswaPageState();
}

class _TambahMahasiswaPageState extends State<TambahMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaC = TextEditingController();
  final _nimC = TextEditingController();
  final _emailC = TextEditingController();
  final _semC = TextEditingController();
  final _namaF = FocusNode();
  AutovalidateMode _mode = AutovalidateMode.disabled;
  Map<String, String>? _hasil;

  @override
  void dispose() {
    _namaC.dispose(); _nimC.dispose(); _emailC.dispose(); _semC.dispose(); _namaF.dispose();
    super.dispose();
  }

  void _simpan() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() => _hasil = {'nama': _namaC.text.trim(), 'nim': _nimC.text.trim(), 'email': _emailC.text.trim(), 'semester': _semC.text.trim()});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data ${_hasil!['nama']} valid.')));
    } else {
      setState(() => _mode = AutovalidateMode.onUserInteraction);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Periksa kembali isian yang ditandai merah.')));
    }
  }

  void _kosongkan() {
    _formKey.currentState!.reset();
    _namaC.clear(); _nimC.clear(); _emailC.clear(); _semC.clear();
    setState(() { _hasil = null; _mode = AutovalidateMode.disabled; });
    _namaF.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, autovalidateMode: _mode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: _namaC, focusNode: _namaF, autofocus: true, textCapitalization: TextCapitalization.words, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Nama lengkap', hintText: 'mis. Rina Amelia', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()), validator: validasiNama),
              const SizedBox(height: 16),
              TextFormField(controller: _nimC, keyboardType: TextInputType.number, textInputAction: TextInputAction.next, inputFormatters: [FilteringTextInputFormatter.digitsOnly], maxLength: 12, decoration: const InputDecoration(labelText: 'NIM', hintText: 'hanya angka', prefixIcon: Icon(Icons.badge), border: OutlineInputBorder()), validator: validasiNim),
              const SizedBox(height: 8),
              TextFormField(controller: _emailC, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Email', hintText: 'nama@kampus.ac.id', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()), validator: validasiEmail),
              const SizedBox(height: 16),
              TextFormField(controller: _semC, keyboardType: TextInputType.number, textInputAction: TextInputAction.done, inputFormatters: [FilteringTextInputFormatter.digitsOnly], maxLength: 2, decoration: const InputDecoration(labelText: 'Semester', hintText: '1 sampai 14', prefixIcon: Icon(Icons.school), border: OutlineInputBorder()), validator: validasiSemester, onFieldSubmitted: (_) => _simpan()),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: _simpan, icon: const Icon(Icons.save), label: const Text('Simpan')),
              const SizedBox(height: 8),
              OutlinedButton.icon(onPressed: _kosongkan, icon: const Icon(Icons.refresh), label: const Text('Kosongkan')),
              if (_hasil != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Pratinjau data valid', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      BarisInfo(label: 'Nama', nilai: _hasil!['nama']!),
                      BarisInfo(label: 'NIM', nilai: _hasil!['nim']!),
                      BarisInfo(label: 'Email', nilai: _hasil!['email']!),
                      BarisInfo(label: 'Semester', nilai: _hasil!['semester']!),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DetailMahasiswaPage extends StatelessWidget {
  const DetailMahasiswaPage({super.key, required this.mahasiswa});
  final Map<String, String> mahasiswa;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BarisInfo(label: 'Nama', nilai: mahasiswa['nama'] ?? '-'),
            BarisInfo(label: 'NIM', nilai: mahasiswa['nim'] ?? '-'),
            BarisInfo(label: 'Program Studi', nilai: mahasiswa['prodi'] ?? '-'),
            BarisInfo(label: 'Semester', nilai: mahasiswa['semester'] ?? '-'),
            BarisInfo(label: 'Email', nilai: mahasiswa['email'] ?? '-'),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back), label: const Text('Kembali ke Dashboard')),
          ],
        ),
      ),
    );
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});
  static const Map<String, String> profil = {'Nama': 'Rina Amelia', 'NIM': '2023001', 'Program Studi': 'Sistem Informasi', 'Semester': '5', 'Email': 'rina@contoh.ac.id'};
  static const List<String> keahlian = ['Flutter', 'Basis Data', 'Desain UI'];
  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa'), backgroundColor: warna.primaryContainer),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: warna.primaryContainer, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(profil['Nama']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4), Text('${profil['NIM']} · ${profil['Program Studi']}'),
                  ])),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Identitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final d in profil.entries) BarisInfo(label: d.key, nilai: d.value),
            const SizedBox(height: 24),
            const Text('Keahlian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final i in keahlian) Row(children: [Icon(Icons.check_circle, color: warna.primary), const SizedBox(width: 8), Text(i)]),
          ],
        ),
      ),
    );
  }
}

class BarisInfo extends StatelessWidget {
  const BarisInfo({super.key, required this.label, required this.nilai});
  final String label;
  final String nilai;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          const Text(': '),
          Expanded(child: Text(nilai)),
        ],
      ),
    );
  }
}

class SapaPage extends StatefulWidget {
  const SapaPage({super.key});

  @override
  State<SapaPage> createState() => _SapaPageState();
}

class _SapaPageState extends State<SapaPage> {
  String _nama = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SapaPage')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: (teks) => _nama = teks,
            ),
            const SizedBox(height: 20),
            Text('Halo, $_nama!'),
          ],
        ),
      ),
    );
  }
}
