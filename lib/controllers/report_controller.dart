import 'package:flutter/material.dart';
import '../models/transaksi_model.dart';
import '../services/sqlite_service.dart';

// Enum untuk mempermudah pengelolaan periode waktu
enum ReportPeriod { harian, mingguan, bulanan, tahunan }

class ReportController extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;

  // State privat
  bool _isLoading = false;
  ReportPeriod _selectedPeriod = ReportPeriod.harian; // Default periode harian
  List<Transaksi> _transactions = [];
  double _pemasukan = 0.0;
  double _pengeluaran = 0.0; // Untuk nanti jika ada transaksi pembelian

  // Getter publik agar UI bisa membaca state
  bool get isLoading => _isLoading;
  ReportPeriod get selectedPeriod => _selectedPeriod;
  // BARU: Getter publik untuk daftar transaksi
  List<Transaksi> get transactions => _transactions; // <-- Tambahkan baris ini
  double get pemasukan => _pemasukan;
  double get pengeluaran => _pengeluaran;
  double get keuntungan => _pemasukan - _pengeluaran; // Keuntungan dihitung langsung

  ReportController() {
    // Langsung muat laporan harian saat controller pertama kali dibuat
    fetchLaporan();
  }

  /// Fungsi utama untuk mengambil dan memproses data laporan
  Future<void> fetchLaporan() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Tentukan rentang tanggal berdasarkan periode yang dipilih
      final now = DateTime.now();
      DateTime startDate;

      switch (_selectedPeriod) {
        case ReportPeriod.harian:
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case ReportPeriod.mingguan:
        // Mengambil hari Senin pada minggu ini
          startDate = now.subtract(Duration(days: now.weekday - 1));
          startDate = DateTime(startDate.year, startDate.month, startDate.day);
          break;
        case ReportPeriod.bulanan:
          startDate = DateTime(now.year, now.month, 1);
          break;
        case ReportPeriod.tahunan:
          startDate = DateTime(now.year, 1, 1);
          break;
      }

      // Ambil data dari database
      _transactions = await _sqliteService.getTransaksiByDateRange(startDate, now);

      // Hitung total pemasukan dan pengeluaran
      _calculateTotals();

    } catch (e) {
      print("Error in ReportController.fetchLaporan: $e");
      // Opsional: Kosongkan data laporan jika terjadi error untuk mencegah crash lebih lanjut
      _transactions = [];
      _pemasukan = 0.0;
      _pengeluaran = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fungsi untuk menghitung total dari transaksi yang sudah diambil
  void _calculateTotals() {
    _pemasukan = 0;
    _pengeluaran = 0;
    for (var trx in _transactions) {
      if (trx.jenisTransaksi == 'Penjualan') {
        _pemasukan += trx.total;
      } else if (trx.jenisTransaksi == 'Pembelian') {
        _pengeluaran += trx.total;
      }
    }
  }

  /// Fungsi untuk mengubah periode filter dan memuat ulang laporan
  void changePeriod(ReportPeriod newPeriod) {
    if (_selectedPeriod != newPeriod) {
      _selectedPeriod = newPeriod;
      fetchLaporan(); // Panggil fetchLaporan untuk memuat data sesuai periode baru
    }
  }
}