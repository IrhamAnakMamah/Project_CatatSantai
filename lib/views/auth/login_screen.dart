import 'package:catatsantai/views/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  // === PERUBAHAN UTAMA 1: Tambahkan parameter ke constructor ===
  final bool showSuccessSnackbar;
  final String? snackbarMessage;

  const LoginPage({
    super.key,
    this.showSuccessSnackbar = false,
    this.snackbarMessage,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // === PERUBAHAN UTAMA 2: Tampilkan SnackBar jika diminta ===
    if (widget.showSuccessSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.snackbarMessage ?? 'Operasi berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    try {
      await authController.login(
        _phoneController.text,
        _passwordController.text,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: Stack(
        children: [
          // Background shapes tidak berubah
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Masuk', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D4A4B))),
                      const SizedBox(height: 30),
                      const Text('No. Handphone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D4A4B))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Masukkan No. Handphone',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF1D4A4B), width: 2.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D4A4B))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Password',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF1D4A4B), width: 2.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey[600]),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ));
                          },
                          child: const Text('Lupa password?', style: TextStyle(color: Color(0xFF4FC0BD), fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Consumer<AuthController>(
                        builder: (context, controller, child) {
                          return controller.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A8EEB),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                            ),
                            child: const Text('Masuk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum punya akun? ', style: TextStyle(color: Color(0xFF1D4A4B))),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ));
                            },
                            child: const Text('Daftar', style: TextStyle(color: Color(0xFF6A8EEB), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}