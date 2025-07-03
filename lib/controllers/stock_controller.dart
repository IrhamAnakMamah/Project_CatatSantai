// lib/controllers/stock_controller.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/barang_model.dart';
import '../models/detail_transaksi_model.dart';
import '../models/notification_model.dart';
import '../services/sqlite_service.dart';
import 'auth_controller.dart';
import 'notification_controller.dart';
import 'report_controller.dart'; // Impor ReportController
import 'dart:math';

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

  // === PERUBAHAN UTAMA DI SINI ===
  /// Menambahkan barang baru dan mencatat transaksi pembelian awalnya.
  Future<void> addBarang(BuildContext context, Barang barang) async {
    _setLoading(true);
    try {
      // Ambil ID pengguna yang sedang login.
      final authController = Provider.of<AuthController>(context, listen: false);
      if (authController.currentUser == null) {
        throw Exception("Pengguna tidak ditemukan, tidak bisa menambah barang.");
      }
      final idPengguna = authController.currentUser!.id!;

      // Panggil fungsi createBarang yang sudah diperbarui dengan idPengguna.
      // Fungsi ini akan menangani insert barang dan insert transaksi secara atomik.
      final barangBaru = await _sqliteService.createBarang(barang, idPengguna);

      // Refresh daftar barang di UI
      await fetchBarang();

      // Refresh laporan karena ada transaksi pembelian baru yang tercatat.
      Provider.of<ReportController>(context, listen: false).fetchLaporan();

      // Periksa notifikasi stok rendah.
      await checkAndCreateLowStockNotification(context, barangBaru);

    } catch (e) {
      print("Error saat addBarang di StockController: $e");
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateBarang(BuildContext context, Barang barang) async {
    _setLoading(true);
    await _sqliteService.updateBarang(barang);
    await fetchBarang();
    await checkAndCreateLowStockNotification(context, barang);
    _setLoading(false);
  }

  Future<void> deleteBarang(int id) async {
    _setLoading(true);
    await _sqliteService.deleteBarang(id);
    await fetchBarang();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Menambah stok untuk barang yang sudah ada (restock).
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
        throw Exception("Pengguna tidak ditemukan, tidak bisa melakukan restock.");
      }
      final idPengguna = authController.currentUser!.id!;

      final Barang barangToRestock = await _sqliteService.getBarangById(idBarang);
      final List<DetailTransaksi> restockDetails = [
        DetailTransaksi(idBarang: idBarang, jumlah: jumlahTambah, hargaSatuan: barangToRestock.hargaModal, subtotal: barangToRestock.hargaModal * jumlahTambah, keuntungan: 0)
      ];

      await _sqliteService.createPembelian(idBarang: idBarang, jumlahTambah: jumlahTambah, totalBiaya: totalBiaya, idPengguna: idPengguna, details: restockDetails);

      await fetchBarang();
      final Barang updatedBarang = _barangList.firstWhere((b) => b.id == idBarang);
      Provider.of<ReportController>(context, listen: false).fetchLaporan();
      await checkAndCreateLowStockNotification(context, updatedBarang);
    } catch (e) {
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAndCreateLowStockNotification(BuildContext context, Barang barang) async {
    if (barang.stokAwal == 0 || barang.id == null) return;
    final int lowStockThreshold = (barang.stokAwal * 0.10).ceil();
    if (barang.stokSaatIni <= lowStockThreshold && barang.stokSaatIni > 0) {
      final message = 'Stok ${barang.namaBarang} menipis! Sisa ${barang.stokSaatIni} unit.';
      final notification = NotificationItem(idBarang: barang.id, message: message, type: 'stok_rendah', timestamp: DateTime.now());
      await _sqliteService.createNotification(notification);
      if (context.mounted) {
        Provider.of<NotificationController>(context, listen: false).fetchNotifications();
      }
    } else if (barang.stokSaatIni == 0) {
      final message = 'Stok ${barang.namaBarang} habis!';
      final notification = NotificationItem(idBarang: barang.id, message: message, type: 'stok_habis', timestamp: DateTime.now());
      await _sqliteService.createNotification(notification);
      if (context.mounted) {
        Provider.of<NotificationController>(context, listen: false).fetchNotifications();
      }
    }
  }
}