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

  // BARU: Metode untuk menandai notifikasi sebagai sudah dibaca
  Future<void> markNotificationAsRead(int notificationId) async {
    // Panggil service untuk memperbarui status di database
    await _sqliteService.updateNotificationReadStatus(notificationId, true);
    // Setelah diupdate di DB, refresh daftar notifikasi di controller
    // agar UI juga terupdate secara otomatis
    await fetchNotifications();
  }

// Anda bisa menambahkan fungsi lain di sini, misalnya:
// - Menghapus notifikasi
}