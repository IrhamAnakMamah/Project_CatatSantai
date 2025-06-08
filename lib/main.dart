import 'package:catatsantai/controllers/stock_controller.dart';
import 'package:catatsantai/views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'views/auth/login_screen.dart'; // Sesuai nama file Anda
import 'views/transaksi/transaction_page.dart'; // Halaman utama setelah login

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => StockController()),
        // Daftarkan controller lain di sini nanti
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catat Santai',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Widget ini berfungsi sebagai "penjaga" yang mengarahkan pengguna
/// berdasarkan status login dari AuthController.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer akan "mendengarkan" perubahan (notifyListeners) dari AuthController
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        if (authController.isLoggedIn) {
          return const TransactionPage(); // Jika sudah login, tampilkan halaman utama
        } else {
          return const LoginPage(); // Jika belum, tampilkan halaman login
        }
      },
    );
  }
}
