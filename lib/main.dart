import 'package:catatsantai/views/pengaturan/initial_profile_setup_page.dart';
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
import 'utils/dummy_data_generator.dart';
import 'views/components/login_success_dialog.dart';

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
        // Jika pengguna sudah login
        if (authController.isLoggedIn) {
          // Periksa apakah dia sudah melengkapi profil
          if (authController.hasCompletedProfile) {
            // Jika sudah, arahkan ke halaman utama
            return const DataInitializer(child: MainPage());
          } else {
            // Jika belum, arahkan ke halaman setup profil
            return const InitialProfileSetupPage();
          }
        }
        // Jika belum login, arahkan ke halaman login
        else {
          return const LoginPage();
        }
      },
    );
  }
}

class DataInitializer extends StatefulWidget {
  final Widget child;
  const DataInitializer({super.key, required this.child});

  @override
  State<DataInitializer> createState() => _DataInitializerState();
}

class _DataInitializerState extends State<DataInitializer> {
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      populateDummyData(context);
      if (!_isDialogShown) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) => const LoginSuccessDialog(),
        );
        setState(() => _isDialogShown = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}