import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../models/pengguna_model.dart';

// 1. Mengubah widget menjadi StatefulWidget
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  // 2. Menambahkan TextEditingController untuk setiap input
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // 3. Menambahkan state untuk visibility password
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    // Penting untuk membersihkan controller
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 4. Menambahkan fungsi untuk menangani logika registrasi
  Future<void> _handleRegister() async {
    // Validasi sederhana untuk password
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan konfirmasi password tidak cocok!')),
      );
      return;
    }

    final authController = Provider.of<AuthController>(context, listen: false);
    final penggunaBaru = Pengguna(
      nomorTelepon: _phoneController.text,
      password: _passwordController.text,
    );

    try {
      await authController.register(penggunaBaru);

      if (mounted) {
        Navigator.pop(context); // Kembali ke halaman login setelah berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil! Silakan masuk.')),
        );
      }
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
    // 5. Ini adalah kode UI asli Anda dengan penyesuaian logika
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: Stack(
        children: [
          // Background shapes (tidak ada perubahan di sini)
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF4FC0BD).withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 60,
                color: const Color(0xFF1D4A4B).withOpacity(0.3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 40,
                color: const Color(0xFF1D4A4B).withOpacity(0.3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF4FC0BD).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Konten utama halaman registrasi (dengan penyesuaian)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Daftar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D4A4B),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // No. Handphone input
                      Text(
                        'No. Handphone',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D4A4B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        // --- PENYESUAIAN ---
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Masukkan No. Handphone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5),
                          ),
                          // ... sisa dekorasi UI Anda ...
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password input
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D4A4B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        // --- PENYESUAIAN ---
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          // ... sisa dekorasi UI Anda ...
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password input
                      Text(
                        'Konfirmasi Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D4A4B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        // --- PENYESUAIAN ---
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Konfirmasi Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          // ... sisa dekorasi UI Anda ...
                        ),
                      ),
                      const SizedBox(height: 40),

                      // "Daftar" button
                      // --- PENYESUAIAN ---
                      Consumer<AuthController>(
                        builder: (context, controller, child) {
                          return controller.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                            // --- PENYESUAIAN ---
                            onPressed: _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A8EEB),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // "Sudah punya akun? Masuk" link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah punya akun? ',
                            style: TextStyle(
                              color: const Color(0xFF1D4A4B),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // --- PENYESUAIAN ---
                              Navigator.pop(context); // Kembali ke halaman login
                            },
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                color: const Color(0xFF6A8EEB),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
