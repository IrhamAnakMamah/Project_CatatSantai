import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/barang_model.dart';
import '../models/transaksi_model.dart';
import '../models/detail_transaksi_model.dart';
import '../services/sqlite_service.dart';
import 'auth_controller.dart';
import 'stock_controller.dart';

class TransactionController extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Fungsi utama untuk memproses dan menyimpan transaksi.
  Future<void> submitTransaction({
    required BuildContext context, // Kita butuh context untuk mengakses controller lain
    required Map<int, int> selectedItems, // Keranjang belanja dari UI
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mengambil controller lain menggunakan Provider
      final authController = Provider.of<AuthController>(context, listen: false);
      final stockController = Provider.of<StockController>(context, listen: false);

      // 1. Siapkan data untuk disimpan
      double grandTotal = 0;
      List<DetailTransaksi> details = [];

      // Loop melalui setiap item di keranjang untuk membuat detail dan menghitung total
      for (var entry in selectedItems.entries) {
        final int barangId = entry.key;
        final int jumlah = entry.value;

        // Ambil data barang dari StockController agar tidak query ulang ke db
        final Barang barang = stockController.barangList.firstWhere((b) => b.id == barangId);

        final double subtotal = barang.harga * jumlah;
        grandTotal += subtotal;

        details.add(DetailTransaksi(
          idBarang: barangId,
          jumlah: jumlah,
          hargaSatuan: barang.harga,
          subtotal: subtotal,
        ));
      }

      // Buat objek header transaksi
      final Transaksi newTransaction = Transaksi(
        idPengguna: authController.currentUser!.id!,
        tanggal: DateTime.now(),
        jenisTransaksi: 'Penjualan',
        total: grandTotal,
      );

      // 2. Panggil DAO untuk menyimpan semuanya ke database
      await _sqliteService.createTransaksi(newTransaction, details);

      // 3. Setelah berhasil, refresh daftar stok di StockController
      await stockController.fetchBarang();

    } catch (e) {
      // Jika terjadi error (misal stok tidak cukup), lemparkan kembali
      _isLoading = false;
      notifyListeners();
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }
}
