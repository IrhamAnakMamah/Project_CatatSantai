// lib/controllers/notification_controller.dart
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/sqlite_service.dart';

class NotificationController extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;

  List<NotificationItem> _notifications = [];
  bool _isLoading = false;

  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;

  NotificationController() {
    fetchNotifications(); // Muat notifikasi saat controller dibuat
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _sqliteService.getAllNotifications();
      // Mengurutkan notifikasi berdasarkan tanggal, paling baru di atas
      _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      print("Error fetching notifications: $e");
      _notifications = []; // Kosongkan daftar jika terjadi error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// Anda bisa menambahkan fungsi lain di sini, misalnya:
// - Menandai notifikasi sebagai sudah dibaca
// - Menghapus notifikasi
}