import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../models/profil_usaha_model.dart';
import '../../services/sqlite_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _namaUsahaController = TextEditingController();
  final _alamatController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    final authController = Provider.of<AuthController>(context, listen: false);
    if (authController.currentUser != null) {
      final profil = await SqliteService.instance.getProfilUsaha(authController.currentUser!.id!);
      if (profil != null && mounted) {
        setState(() {
          _namaUsahaController.text = profil.namaUsaha;
          _alamatController.text = profil.alamat ?? '';
        });
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaUsahaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _simpanPerubahan() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final authController = Provider.of<AuthController>(context, listen: false);

      final profil = ProfilUsaha(
        idPengguna: authController.currentUser!.id!,
        namaUsaha: _namaUsahaController.text,
        alamat: _alamatController.text,
      );

      try {
        await SqliteService.instance.createOrUpdateProfilUsaha(profil);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui!')),
          );
          setState(() => _isEditing = false);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui profil: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      appBar: AppBar(
        title: const Text('Profil Usaha'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1D4A4B),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: () {
                if (_isEditing) {
                  _simpanPerubahan();
                } else {
                  setState(() => _isEditing = true);
                }
              },
              child: Text(
                _isEditing ? 'Simpan' : 'Edit',
                style: const TextStyle(fontSize: 16, color: Color(0xFF6A8EEB), fontWeight: FontWeight.bold),
              ),
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _loadProfileData();
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama Usaha', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D4A4B))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _namaUsahaController,
                enabled: _isEditing,
                // === PERUBAHAN DI SINI ===
                style: TextStyle(
                  color: _isEditing ? Colors.black : Colors.black87,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: !_isEditing,
                  fillColor: Colors.white,
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama usaha tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text('Alamat Usaha', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D4A4B))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _alamatController,
                enabled: _isEditing,
                // === PERUBAHAN DI SINI ===
                style: TextStyle(
                  color: _isEditing ? Colors.black : Colors.black87,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: !_isEditing,
                  fillColor: Colors.white,
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300)
                  ),
                ),
              ),
              const SizedBox(height: 40),

              const Text('Nomor Telepon Terdaftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D4A4B))),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  authController.currentUser?.nomorTelepon ?? 'Tidak tersedia',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}