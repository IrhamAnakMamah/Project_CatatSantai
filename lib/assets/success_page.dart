import 'package:flutter/material.dart';
import 'package:catatsantai/assets/login_screen.dart'; // Import LoginPage untuk navigasi

class SuccessPage extends StatelessWidget { // Nama class diubah menjadi SuccessPage
  const SuccessPage({super.key});

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

          // Main content of the page (centered)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten secara vertikal
                children: [
                  // Checkmark icon inside a circle
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF6A8EEB), // Warna border biru
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: const Color(0xFF6A8EEB), // Warna icon centang biru
                        size: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Title "Sukses!"
                  Text(
                    'Sukses!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D4A4B), // Dark text color
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Descriptive text
                  Text(
                    'Silahkan masuk ke akun anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700], // Grey color
                    ),
                  ),
                  const SizedBox(height: 40),

                  // "Oke" button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to the Login Page and remove all previous routes
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false, // Remove all routes until this one
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A8EEB), // Blue button color
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5, // Button shadow
                      minimumSize: const Size.fromHeight(50), // Full width
                    ),
                    child: Text(
                      'Oke',
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
