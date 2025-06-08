import 'package:flutter/material.dart';
import '../models/pengguna_model.dart';
import '../services/sqlite_service.dart';

class AuthController extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;

  // State privat
  bool _isLoading = false;
  bool _isLoggedIn = false;
  Pengguna? _currentUser;

  // Getter publik agar View bisa membaca state tanpa mengubahnya
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  Pengguna? get currentUser => _currentUser;

  /// Mendaftarkan pengguna baru
  Future<void> register(Pengguna pengguna) async {
    _isLoading = true;
    notifyListeners(); // Beri tahu UI untuk menampilkan loading

    try {
      final existingUser = await _sqliteService.getUserByPhone(pengguna.nomorTelepon);
      if (existingUser != null) {
        throw Exception('Nomor telepon sudah terdaftar.');
      }
      await _sqliteService.registerUser(pengguna);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow; // Lemparkan error agar UI bisa menampilkannya
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Login pengguna
  Future<void> login(String noTelp, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Pengguna? user = await _sqliteService.getUserByPhone(noTelp);

      if (user == null) {
        throw Exception('Nomor telepon tidak ditemukan.');
      }

      if (user.password != password) {
        // PERHATIAN: Di aplikasi nyata, gunakan hashing. Ini untuk demonstrasi.
        throw Exception('Password salah.');
      }

      // Jika berhasil, update state
      _currentUser = user;
      _isLoggedIn = true;
    } catch (e) {
      _isLoggedIn = false;
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
      rethrow;
    }

    _isLoading = false;
    notifyListeners(); // Beri tahu UI bahwa status login berubah
  }

  /// Logout pengguna
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners(); // Beri tahu UI bahwa status logout berubah
  }
}
