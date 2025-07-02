import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/notification_controller.dart';
import 'controllers/report_controller.dart';
import 'controllers/stock_controller.dart';
import 'controllers/transaction_controller.dart';
import 'views/auth/login_screen.dart';
import 'views/main_page.dart';

// Ganti import ini jika Anda meletakkan file dummy_data_generator di lokasi lain
import 'utils/dummy_data_generator.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => StockController()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
        ChangeNotifierProvider(create: (_) => TransactionController()),
        ChangeNotifierProvider(create: (_) => ReportController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
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
          // Ganti MainPage dengan DataInitializer
          return const DataInitializer(child: MainPage());
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

// WIDGET BARU UNTUK MEMANGGIL FUNGSI ANDA DENGAN AMAN
class DataInitializer extends StatefulWidget {
  final Widget child;
  const DataInitializer({super.key, required this.child});

  @override
  State<DataInitializer> createState() => _DataInitializerState();
}

class _DataInitializerState extends State<DataInitializer> {
  @override
  void initState() {
    super.initState();
    // Memanggil fungsi Anda di sini memastikan ia hanya berjalan satu kali.
    // addPostFrameCallback digunakan agar context dijamin sudah siap.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      populateDummyData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Setelah inisialisasi, tampilkan halaman utama aplikasi
    return widget.child;
  }
}