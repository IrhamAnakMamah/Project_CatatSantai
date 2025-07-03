import 'package:flutter/material.dart';
import 'package:catatsantai/views/auth/login_screen.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: Stack(
        children: [
          // Background shapes tidak berubah...
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF6A8EEB),
                        width: 3,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Color(0xFF6A8EEB),
                        size: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Sukses!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D4A4B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Password Anda telah berhasil diatur ulang.\nSilakan masuk dengan password baru Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      // Ini adalah perintah yang benar untuk membersihkan stack
                      // dan kembali ke halaman login.
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A8EEB),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'Kembali ke Login',
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