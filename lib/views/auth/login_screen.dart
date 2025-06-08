import 'package:catatsantai/views/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

// 1. Mengubah widget menjadi StatefulWidget
// Ini diperlukan untuk mengelola TextEditingController dan state lainnya.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // 2. Menambahkan TextEditingController
  // Ini akan kita hubungkan ke TextField di UI Anda.
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // 3. Menambahkan state untuk visibility password (jika diperlukan oleh UI Anda)
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Penting untuk membersihkan controller saat widget tidak lagi digunakan.
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 4. Menambahkan fungsi untuk menangani logika login
  // Fungsi ini akan dipanggil oleh tombol "Masuk" di UI Anda.
  Future<void> _handleLogin() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    try {
      await authController.login(
        _phoneController.text,
        _passwordController.text,
      );
      // Jika berhasil, AuthWrapper akan otomatis menangani navigasi.
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
    // 5. Ini adalah kode UI asli Anda.
    //    Perhatikan komentar berlabel "PENYESUAIAN" untuk melihat bagian mana yang diubah.
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

          // Konten utama halaman login (dengan penyesuaian)
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
                        'Masuk',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D4A4B),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Input No. Handphone
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
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Password
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
                        obscureText: !_isPasswordVisible, // Menggunakan state
                        decoration: InputDecoration(
                          hintText: 'Masukkan Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0),
                          ),
                          suffixIcon: IconButton(
                            // --- PENYESUAIAN ---
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Lupa password?
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Tambahkan navigasi ke halaman lupa password
                          },
                          child: Text(
                            'Lupa password?',
                            style: TextStyle(
                              color: const Color(0xFF4FC0BD),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tombol Masuk
                      // --- PENYESUAIAN ---
                      // Dibungkus dengan Consumer agar bisa menampilkan loading indicator
                      Consumer<AuthController>(
                        builder: (context, controller, child) {
                          return controller.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                            // --- PENYESUAIAN ---
                            onPressed: _handleLogin, // Memanggil fungsi handle login
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A8EEB),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'Masuk',
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

                      // Belum punya akun? Daftar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: TextStyle(
                              color: const Color(0xFF1D4A4B),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // --- PENYESUAIAN ---
                              // Navigasi ke halaman registrasi
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ));
                            },
                            child: Text(
                              'Daftar',
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
