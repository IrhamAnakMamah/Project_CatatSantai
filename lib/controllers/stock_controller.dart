import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/barang_model.dart';
import '../models/detail_transaksi_model.dart';
import '../models/notification_model.dart'; // BARU: Import NotificationModel
import '../services/sqlite_service.dart';
import 'report_controller.dart';
import 'auth_controller.dart';

class StockController extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;

  List<Barang> _barangList = [];
  bool _isLoading = false;

  List<Barang> get barangList => _barangList;
  bool get isLoading => _isLoading;

  StockController() {
    fetchBarang();
  }

  Future<void> fetchBarang() async {
    _setLoading(true);
    try {
      _barangList = await _sqliteService.getAllBarang();
    } catch (e) {
      print("Error saat fetchBarang di StockController: $e");
      _barangList = [];
    }
    _setLoading(false);
  }

  Future<void> addBarang(BuildContext context, Barang barang) async {
    _setLoading(true);
    try {
      final Barang newBarangWithId = await _sqliteService.createBarang(barang);

      final authController = Provider.of<AuthController>(context, listen: false);
      if (authController.currentUser == null) {
        throw Exception('Pengguna belum login atau data pengguna tidak tersedia.');
      }
      final idPengguna = authController.currentUser!.id!;

      final double totalBiayaPengadaan = newBarangWithId.stokAwal * newBarangWithId.hargaModal;

      final List<DetailTransaksi> initialPurchaseDetails = [
        DetailTransaksi(
          idBarang: newBarangWithId.id!,
          jumlah: newBarangWithId.stokAwal,
          hargaSatuan: newBarangWithId.hargaModal,
          subtotal: newBarangWithId.stokAwal * newBarangWithId.hargaModal,
          keuntungan: 0,
        ),
      ];

      await _sqliteService.createPembelian(
        idBarang: newBarangWithId.id!,
        jumlahTambah: newBarangWithId.stokAwal,
        totalBiaya: totalBiayaPengadaan,
        idPengguna: idPengguna,
        details: initialPurchaseDetails,
      );

      await fetchBarang();
      Provider.of<ReportController>(context, listen: false).fetchLaporan();
      // BARU: Periksa stok setelah penambahan barang baru
      _checkAndCreateLowStockNotification(newBarangWithId);

    } catch (e) {
      _setLoading(false);
      rethrow;
    }
    _setLoading(false);
  }

  Future<void> updateBarang(Barang barang) async {
    _setLoading(true);
    await _sqliteService.updateBarang(barang);
    await fetchBarang();
    // BARU: Periksa stok setelah update barang (jika stok_saat_ini diubah)
    _checkAndCreateLowStockNotification(barang);
  }

  Future<void> deleteBarang(int id) async {
    _setLoading(true);
    await _sqliteService.deleteBarang(id);
    await fetchBarang();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> restockBarang({
    required BuildContext context,
    required int idBarang,
    required int jumlahTambah,
    required double totalBiaya,
  }) async {
    _setLoading(true);

    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      if (authController.currentUser == null) {
        throw Exception('Pengguna belum login atau data pengguna tidak tersedia.');
      }
      final idPengguna = authController.currentUser!.id!;

      final Barang barangToRestock = await _sqliteService.getBarangById(idBarang);

      final List<DetailTransaksi> restockDetails = [
        DetailTransaksi(
          idBarang: idBarang,
          jumlah: jumlahTambah,
          hargaSatuan: barangToRestock.hargaModal,
          subtotal: barangToRestock.hargaModal * jumlahTambah,
          keuntungan: 0,
        ),
      ];

      await _sqliteService.createPembelian(
        idBarang: idBarang,
        jumlahTambah: jumlahTambah,
        totalBiaya: totalBiaya,
        idPengguna: idPengguna,
        details: restockDetails,
      );

      await fetchBarang();
      Provider.of<ReportController>(context, listen: false).fetchLaporan();
      // BARU: Periksa stok setelah restock
      _checkAndCreateLowStockNotification(barangToRestock.copyWith(stokSaatIni: barangToRestock.stokSaatIni + jumlahTambah));

    } catch (e) {
      _setLoading(false);
      rethrow;
    }

    _setLoading(false);
  }

  // BARU: Metode untuk memeriksa dan membuat notifikasi stok rendah
  Future<void> _checkAndCreateLowStockNotification(Barang barang) async {
    // Hindari notifikasi jika stok awal 0 atau barang tidak memiliki ID
    if (barang.stokAwal == 0 || barang.id == null) return;

    final double lowStockThreshold = barang.stokAwal * 0.10; // 10% dari stok awal

    if (barang.stokSaatIni <= lowStockThreshold && barang.stokSaatIni > 0) {
      final message = 'Stok ${barang.namaBarang} menipis! Sisa ${barang.stokSaatIni} unit.';
      final notification = NotificationItem(
        idBarang: barang.id,
        message: message,
        type: 'stok_rendah',
        timestamp: DateTime.now(),
      );
      await _sqliteService.createNotification(notification);
      print('Notifikasi stok rendah dibuat: $message'); // Untuk debugging
    } else if (barang.stokSaatIni == 0) {
      final message = 'Stok ${barang.namaBarang} habis!';
      final notification = NotificationItem(
        idBarang: barang.id,
        message: message,
        type: 'stok_habis',
        timestamp: DateTime.now(),
      );
      await _sqliteService.createNotification(notification);
      print('Notifikasi stok habis dibuat: $message'); // Untuk debugging
    }
  }
}