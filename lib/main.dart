import 'package:flutter/material.dart';
// Pastikan nama package di bawah ini SAMA PERSIS dengan nama project lo di pubspec.yaml
// Contoh: Jika nama project lo 'catatsantai_app', maka jadi 'package:catatsantai_app/assets/notification_page.dart'
import 'package:catatsantai/assets/notification_page.dart'; // Import halaman NotificationPage

void main() {
  // Ini adalah fungsi utama yang menjalankan aplikasi Flutter lo.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp adalah widget inti untuk aplikasi Material Design.
    return MaterialApp(
      // Judul aplikasi yang akan muncul di task switcher (recent apps).
      title: 'Catat Santai App',
      // Tema aplikasi lo. Di sini pake tema default biru.
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Halaman pertama yang akan ditampilkan saat aplikasi dijalankan.
      // Langsung tampilkan halaman NotificationPage sebagai home.
      home: const NotificationPage(), // Langsung panggil NotificationPage sebagai halaman utama
      // Ini buat ngilangin banner 'DEBUG' di pojok kanan atas pas development.
      debugShowCheckedModeBanner: false,
    );
  }
}
