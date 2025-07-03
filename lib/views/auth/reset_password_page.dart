import 'package:catatsantai/views/auth/login_screen.dart'; // Impor LoginPage
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 4 karakter.')),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan konfirmasi password tidak cocok.')),
      );
      return;
    }

    final authController = Provider.of<AuthController>(context, listen: false);
    try {
      await authController.completePasswordReset(password);
      authController.logout(); // Pastikan state dibersihkan

      if (mounted) {
        // === PERUBAHAN UTAMA DI SINI ===
        // Langsung kembali ke halaman Login dan hapus semua halaman sebelumnya.
        // Kirim pesan untuk ditampilkan di SnackBar.
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginPage(
              showSuccessSnackbar: true,
              snackbarMessage: 'Password berhasil diubah. Silakan login kembali.',
            ),
          ),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengatur ulang password: ${e.toString()}')),
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1D4A4B), size: 24),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('Atur Ulang Password', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D4A4B))),
                  const SizedBox(height: 10),
                  Text('Silakan isi password baru Anda.', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  const SizedBox(height: 30),
                  const Text('Password Baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D4A4B))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password baru',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Konfirmasi Password Baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D4A4B))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Konfirmasi password baru',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Consumer<AuthController>(
                    builder: (context, controller, child) {
                      return controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                        onPressed: _handleConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A8EEB),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 5,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Konfirmasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}