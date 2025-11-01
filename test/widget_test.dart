import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_notes/main.dart'; // Ganti dengan nama project kamu

void main() {
  testWidgets('Aplikasi dapat diluncurkan dan menampilkan judul', (
    WidgetTester tester,
  ) async {
    // Jalankan aplikasi
    await tester.pumpWidget(const MyApp());

    // Tunggu widget ter-build
    await tester.pumpAndSettle();

    // Cek apakah teks dan tombol muncul
    expect(find.text('Catatan Harian'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
