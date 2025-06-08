import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // State untuk mengontrol visibilitas password
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background halaman, mirip dengan warna di design Figma
      backgroundColor: const Color(0xFFF7F5EC), // Warna krem muda
      body: Stack(
        children: [
          // Background shapes (lingkaran dan tanda plus)
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF4FC0BD).withOpacity(0.8), // Tosca
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
                color: const Color(0xFF1D4A4B).withOpacity(0.3), // Darker tosca, semi-transparent
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
                color: const Color(0xFF4FC0BD).withOpacity(0.5), // Tosca, semi-transparent
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Konten utama halaman
          SafeArea( // Untuk menghindari overlap dengan status bar
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
                children: [
                  // Tombol kembali
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.8), // Warna putih transparan
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new, // Icon panah ke kiri
                        color: const Color(0xFF1D4A4B),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Judul "Password Berhasil di Reset"
                  Text(
                    'Password Berhasil di Reset',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D4A4B), // Warna teks gelap
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Instruksi
                  Text(
                    'Password anda berhasil di reset. silahkan isi password baru anda',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700], // Warna abu-abu
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Input Password Baru
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
                    obscureText: !_isPasswordVisible, // Kontrol visibilitas password
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
                  const SizedBox(height: 20),

                  // Input Konfirmasi Password
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
                    obscureText: !_isConfirmPasswordVisible, // Kontrol visibilitas konfirmasi password
                    decoration: InputDecoration(
                      hintText: 'Konfirmasi Password',
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Tombol Konfirmasi
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Tambahkan logika untuk proses reset password baru
                      print('Tombol Konfirmasi reset password ditekan!'); // Contoh aksi
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A8EEB), // Warna biru tombol
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5, // Bayangan tombol
                      minimumSize: const Size.fromHeight(50), // Lebar penuh
                    ),
                    child: Text(
                      'Konfirmasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
