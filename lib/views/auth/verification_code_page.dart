import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk FilteringTextInputFormatter

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  // List of TextEditingControllers for each digit input
  final List<TextEditingController> _codeControllers =
  List.generate(5, (index) => TextEditingController());
  // List of FocusNodes for each digit input
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  @override
  void dispose() {
    // Dispose all controllers and focus nodes when the widget is removed from the tree
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color of the page, similar to the Figma design
      backgroundColor: const Color(0xFFF7F5EC), // Light cream color
      body: Stack(
        children: [
          // Background shapes (circles and plus signs)
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

          // Main content of the page
          SafeArea( // To avoid overlap with the status bar
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Go back to the previous page
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.8), // Transparent white color
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new, // Back arrow icon
                        color: const Color(0xFF1D4A4B),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Title "Cek pesan anda"
                  Text(
                    'Cek pesan anda',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D4A4B), // Dark text color
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Instruction text
                  Text(
                    'Kami mengirim pesan ke nomor anda masukkan 5 digit code yang kami kirim',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700], // Grey color
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 5-digit code input fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute evenly
                    children: List.generate(5, (index) {
                      return SizedBox(
                        width: 50, // Width of each input box
                        child: TextField(
                          controller: _codeControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // Only allow digits
                            LengthLimitingTextInputFormatter(1), // Limit to 1 character
                          ],
                          decoration: InputDecoration(
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
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onChanged: (value) {
                            if (value.length == 1) {
                              // Move focus to the next field if a digit is entered
                              if (index < _focusNodes.length - 1) {
                                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                              } else {
                                // If it's the last field, unfocus keyboard
                                _focusNodes[index].unfocus();
                              }
                            } else if (value.isEmpty) {
                              // Move focus to the previous field if backspace is pressed
                              if (index > 0) {
                                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                              }
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),

                  // "Verifikasi Kode" button
                  ElevatedButton(
                    onPressed: () {
                      // Get the entered code
                      String enteredCode = _codeControllers.map((c) => c.text).join();
                      print('Kode Verifikasi: $enteredCode');
                      // TODO: Add logic to verify the code
                      // Example: Navigate to ResetPasswordPage after successful verification
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
                      // );
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
                      'Verifikasi Kode',
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
