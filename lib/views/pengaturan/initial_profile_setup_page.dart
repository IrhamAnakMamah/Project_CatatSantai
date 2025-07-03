import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../models/profil_usaha_model.dart'; // Pastikan import ini ada
import '../../services/sqlite_service.dart';

class InitialProfileSetupPage extends StatefulWidget {
  const InitialProfileSetupPage({super.key});

  @override
  State<InitialProfileSetupPage> createState() => _InitialProfileSetupPageState();
}

class _InitialProfileSetupPageState extends State<InitialProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaUsahaController = TextEditingController();
  final _alamatController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaUsahaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _simpanProfil() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authController = Provider.of<AuthController>(context, listen: false);
      if (authController.currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Pengguna tidak ditemukan!')),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Baris ini sekarang akan berfungsi karena ProfilUsaha sudah didefinisikan
      final profil = ProfilUsaha(
        idPengguna: authController.currentUser!.id!,
        namaUsaha: _namaUsahaController.text,
        alamat: _alamatController.text,
      );

      try {
        final dbService = SqliteService.instance;
        await dbService.createOrUpdateProfilUsaha(profil);
        await authController.checkUserProfileStatus();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan profil: $e')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Selamat Datang!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D4A4B)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lengkapi profil usaha Anda untuk memulai.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _namaUsahaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Usaha',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama usaha tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _alamatController,
                      decoration: InputDecoration(
                        labelText: 'Alamat Usaha (Opsional)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: _simpanProfil,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A8EEB),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Simpan dan Lanjutkan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}