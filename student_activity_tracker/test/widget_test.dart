import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import ini sekarang diperlukan karena kita akan menguji widget dari file ini.
import 'package:student_activity_tracker/main.dart'; 

void main() {
  // Test untuk memastikan aplikasi dapat dijalankan dan menampilkan elemen kunci
  testWidgets('Aplikasi Feedback Form menampilkan judul yang benar', (WidgetTester tester) async {
    // Bangun aplikasi dan picu frame
    await tester.pumpWidget(const StudentActivityTracker());

    // Verifikasi bahwa judul utama formulir ("Berikan Masukan Anda") terlihat.
    expect(find.text('Berikan Masukan Anda'), findsOneWidget);

    // Verifikasi bahwa teks motivasi ("Kami Ingin Mendengar Anda!") terlihat.
    expect(find.text('Kami Ingin Mendengar Anda!'), findsOneWidget);

    // Verifikasi bahwa tombol utama "Kirim Masukan" terlihat.
    expect(find.text('Kirim Masukan'), findsOneWidget);
    
    // Verifikasi bahwa input field untuk Nama juga terlihat
    expect(find.byType(TextField), findsNWidgets(2)); // Ada 2 TextField (Nama & Komentar)
  });

  // Test untuk memverifikasi fungsionalitas rating bintang
  testWidgets('Rating bintang berfungsi dengan benar', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentActivityTracker());

    // Rating default adalah 3. Kita klik bintang ke-5.
    // Cari 5 ikon bintang dan klik yang ke-5 (indeks 4).
    final starIcons = find.byIcon(Icons.star_border_rounded);
    
    // Klik ikon bintang ke-5 (widget 4 dari 5)
    await tester.tap(starIcons.at(4));
    await tester.pump(); 

    // Verifikasi bahwa teks rating sekarang menunjukkan 5 dari 5
    expect(find.text('Rating: 5 dari 5'), findsOneWidget);
  });
}
