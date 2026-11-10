
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belajar_navigasi/main.dart';

void main() {
  testWidgets('Halaman dashboard tampil', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Dashboard Akademik'), findsOneWidget);
    expect(find.text('Daftar Mahasiswa'), findsOneWidget);
  });

  testWidgets('Tombol Tambah membuka formulir', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    expect(find.text('Tambah Mahasiswa'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
  });
}
