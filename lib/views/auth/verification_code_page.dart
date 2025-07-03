import 'package:catatsantai/views/auth/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final List<TextEditingController> _codeControllers = List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode Verifikasi (Dummy): 12345'),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _handleVerify() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final enteredCode = _codeControllers.map((c) => c.text).join();

    if (enteredCode.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode verifikasi harus 5 digit.')),
      );
      return;
    }

    try {
      final isCorrect = await authController.verifyResetCode(enteredCode);
      if (isCorrect && mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResetPasswordPage(),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kode verifikasi salah.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
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
          SafeArea(
            child: Padding(
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
                  const Text(
                    'Cek pesan anda',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D4A4B)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kami mengirim pesan ke nomor anda masukkan 5 digit code yang kami kirim',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      return SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _codeControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onChanged: (value) {
                            if (value.length == 1 && index < 4) {
                              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  Consumer<AuthController>(
                    builder: (context, controller, child) {
                      return controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                        onPressed: _handleVerify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A8EEB),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 5,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Verifikasi Kode', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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