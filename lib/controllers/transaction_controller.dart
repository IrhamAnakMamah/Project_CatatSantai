import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/barang_model.dart';
import '../models/transaksi_model.dart';
import '../models/detail_transaksi_model.dart';
import '../services/sqlite_service.dart';
import 'auth_controller.dart';
import 'stock_controller.dart';
import 'report_controller.dart';

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
      final authController = Provider.of<AuthController>(context, listen: false);
      final stockController = Provider.of<StockController>(context, listen: false);

      double grandTotal = 0;
      List<DetailTransaksi> details = [];
      List<Barang> itemsAffected = []; // BARU: Untuk menyimpan barang yang terkena dampak

      for (var entry in selectedItems.entries) {
        final int barangId = entry.key;
        final int jumlah = entry.value;

        // Mendapatkan objek Barang dari daftar barang di StockController
        // Pastikan barang dengan ID ini ada sebelum melanjutkan
        final Barang barang = stockController.barangList.firstWhere(
              (b) => b.id == barangId,
          orElse: () => throw Exception('Barang dengan ID $barangId tidak ditemukan.'),
        );

        final double subtotal = barang.harga * jumlah;
        grandTotal += subtotal;

        final double keuntunganPerItem = barang.harga - barang.hargaModal;
        final double totalKeuntunganItem = keuntunganPerItem * jumlah;

        details.add(DetailTransaksi(
          idBarang: barangId,
          jumlah: jumlah,
          hargaSatuan: barang.harga,
          subtotal: subtotal,
          keuntungan: totalKeuntunganItem,
        ));
        itemsAffected.add(barang); // Tambahkan barang yang terkena dampak
      }

      // Buat objek header transaksi
      final Transaksi newTransaction = Transaksi(
        idPengguna: authController.currentUser!.id!,
        tanggal: DateTime.now(),
        jenisTransaksi: 'Penjualan',
        total: grandTotal,
      );

      // Panggil DAO untuk menyimpan semuanya ke database
      await _sqliteService.createTransaksi(newTransaction, details);

      // Setelah berhasil, refresh daftar stok di StockController
      await stockController.fetchBarang();
      // Refresh laporan di ReportController juga
      Provider.of<ReportController>(context, listen: false).fetchLaporan();

      // BARU: Periksa notifikasi stok rendah/habis untuk setiap barang yang terjual
      for (var originalBarang in itemsAffected) {
        // Dapatkan data barang terbaru setelah fetchBarang()
        final updatedBarang = stockController.barangList.firstWhere((b) => b.id == originalBarang.id);
        await stockController.checkAndCreateLowStockNotification(context, updatedBarang);
      }

    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }
}