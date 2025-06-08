import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import '../services/sqlite_service.dart';

class StockController extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;

  // State privat untuk daftar barang dan status loading
  List<Barang> _barangList = [];
  bool _isLoading = false;

  // Getter publik agar UI bisa mengakses state ini
  List<Barang> get barangList => _barangList;
  bool get isLoading => _isLoading;

  StockController() {
    // Langsung muat data barang saat controller pertama kali dibuat
    fetchBarang();
  }

  /// Mengambil semua data barang dari database dan memperbarui state.
  Future<void> fetchBarang() async {
    _isLoading = true;
    notifyListeners();

    try {
      _barangList = await _sqliteService.getAllBarang();
    } catch (e) {
      // Handle error jika ada
      print(e);
    }

    _isLoading = false;
    notifyListeners(); // Beri tahu UI untuk update dengan data baru
  }

  /// Menambahkan barang baru ke database, lalu memuat ulang daftar barang.
  Future<void> addBarang(Barang barang) async {
    _isLoading = true;
    notifyListeners();

    await _sqliteService.createBarang(barang);
    await fetchBarang(); // Muat ulang daftar untuk menampilkan data baru
  }

  /// Mengupdate barang yang ada di database, lalu memuat ulang daftar barang.
  Future<void> updateBarang(Barang barang) async {
    _isLoading = true;
    notifyListeners();

    await _sqliteService.updateBarang(barang);
    await fetchBarang();
  }

  /// Menghapus barang dari database, lalu memuat ulang daftar barang.
  Future<void> deleteBarang(int id) async {
    _isLoading = true;
    notifyListeners();

    await _sqliteService.deleteBarang(id);
    await fetchBarang();
  }
}
