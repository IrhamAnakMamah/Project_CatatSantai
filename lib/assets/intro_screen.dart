import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4FC0BD), // This is an approximate turquoise color from the image
      body: Center(
        child: Container(
          width: 200, // Adjust circle size, this is just an estimate
          height: 200, // Adjust circle size
          decoration: BoxDecoration(
            color: const Color(0xFFF7F5EC), // This is an approximate cream/off-white color
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Catat',
                style: TextStyle(
                  fontFamily: 'Pacifico', // Example font, needs to be imported if different
                  fontSize: 50, // Adjust font size
                  fontWeight: FontWeight.bold, // If the font supports it
                  color: const Color(0xFF1D4A4B), // Approximate color for "Catat" text
                ),
              ),
              const SizedBox(height: 5), // Space between "Catat" and "SANTAI"
              Text(
                'SANTAI',
                style: TextStyle(
                  fontFamily: 'Montserrat', // Example font, needs to be imported
                  fontSize: 20, // Adjust font size
                  letterSpacing: 3, // Letter spacing
                  color: const Color(0xFF1D4A4B), // Approximate color for "SANTAI" text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
