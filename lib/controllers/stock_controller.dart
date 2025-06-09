import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import '../services/sqlite_service.dart';

class StockController extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;

  // State privat untuk daftar barang dan status loading
  List<Barang> _barangList = [];
  bool _isLoading = false;

  // Getter publik agar UI bisa mengakses state ini dengan aman (read-only)
  List<Barang> get barangList => _barangList;
  bool get isLoading => _isLoading;

  // Constructor ini akan dipanggil saat StockController pertama kali dibuat.
  // Kita langsung memanggil fetchBarang() agar data stok segera dimuat.
  StockController() {
    fetchBarang();
  }

  /// Mengambil semua data barang dari database dan memperbarui state.
  Future<void> fetchBarang() async {
    _setLoading(true);
    try {
      _barangList = await _sqliteService.getAllBarang();
    } catch (e) {
      print("Error saat fetchBarang: $e");
      _barangList = []; // Kosongkan daftar jika terjadi error
    }
    _setLoading(false);
  }

  /// Menambahkan barang baru ke database, lalu memuat ulang daftar barang.
  Future<void> addBarang(Barang barang) async {
    _setLoading(true);
    await _sqliteService.createBarang(barang);
    // Setelah menambah, panggil fetchBarang() untuk mendapatkan daftar terbaru
    // yang sudah terurut dan menyertakan data baru.
    await fetchBarang();
  }

  /// Mengupdate barang yang ada di database, lalu memuat ulang daftar barang.
  Future<void> updateBarang(Barang barang) async {
    _setLoading(true);
    await _sqliteService.updateBarang(barang);
    await fetchBarang();
  }

  /// Menghapus barang dari database, lalu memuat ulang daftar barang.
  Future<void> deleteBarang(int id) async {
    _setLoading(true);
    await _sqliteService.deleteBarang(id);
    await fetchBarang();
  }

  // Fungsi helper internal untuk mengelola state loading dan memberitahu UI
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Ini adalah perintah kunci untuk memberitahu UI agar refresh
  }
}
