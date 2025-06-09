import 'controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/stock_controller.dart'; // 1. Impor StockController
import 'views/main_page.dart';
import 'views/auth/login_screen.dart'; // Sesuaikan dengan nama file login Anda

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        // 2. Daftarkan StockController di sini
        ChangeNotifierProvider(create: (_) => StockController()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
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
        // Anda bisa menyesuaikan tema di sini
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4FC0BD)),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        if (authController.isLoggedIn) {
          return const MainPage();
        } else {
          // Ganti LoginPage() jika nama class di file login_screen.dart berbeda
          return const LoginPage();
        }
      },
    );
  }
}
