import 'package:flutter/material.dart';
import '../models/pengguna_model.dart';
import '../services/sqlite_service.dart';

class AuthController extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;
  Pengguna? _currentUser;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _hasCompletedProfile = false;

  String? _phoneForPasswordReset;
  final String _dummyVerificationCode = "12345";

  Pengguna? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasCompletedProfile => _hasCompletedProfile;

  Future<void> login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _sqliteService.getUserByPhone(phone);

      if (user != null && user.password == password) {
        _currentUser = user;
        _isLoggedIn = true;
        _hasCompletedProfile = user.sudahIsiProfil;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Nomor telepon atau password salah.');
      }
    } catch (e) {
      _isLoading = false;
      _isLoggedIn = false;
      _hasCompletedProfile = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> checkUserProfileStatus() async {
    if (_currentUser != null) {
      final userFromDb = await _sqliteService.getUserByPhone(_currentUser!.nomorTelepon);
      if (userFromDb != null) {
        _currentUser = userFromDb;
        _hasCompletedProfile = userFromDb.sudahIsiProfil;
        notifyListeners();
      }
    }
  }

  Future<void> startPasswordReset(String phone) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _sqliteService.getUserByPhone(phone);
      if (user == null) {
        throw Exception('Nomor telepon tidak terdaftar.');
      }
      _phoneForPasswordReset = phone;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyResetCode(String code) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    final bool isCodeCorrect = (code == _dummyVerificationCode);
    _isLoading = false;
    notifyListeners();
    return isCodeCorrect;
  }

  // === PERBAIKAN UTAMA DI SINI ===
  /// Menyelesaikan proses reset dengan memanggil service yang sudah diperbarui.
  Future<void> completePasswordReset(String newPassword) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_phoneForPasswordReset == null) {
        throw Exception('Proses reset tidak valid. Silakan ulangi dari awal.');
      }
      // Panggil fungsi yang sudah andal
      await _sqliteService.updateUserPassword(_phoneForPasswordReset!, newPassword);
      // Hapus nomor telepon dari state setelah berhasil
      _phoneForPasswordReset = null;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(Pengguna pengguna) async {
    _isLoading = true;
    notifyListeners();
    try {
      final existingUser = await _sqliteService.getUserByPhone(pengguna.nomorTelepon);
      if (existingUser != null) {
        throw Exception('Nomor telepon sudah terdaftar.');
      }
      await _sqliteService.registerUser(pengguna);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _hasCompletedProfile = false;
    notifyListeners();
  }
}