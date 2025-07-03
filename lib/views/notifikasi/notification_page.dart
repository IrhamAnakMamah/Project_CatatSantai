import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../controllers/notification_controller.dart';
import '../../models/notification_model.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: Stack(
        children: [
          // Background shapes - tidak ada perubahan
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF4FC0BD).withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 60,
                color: const Color(0xFF1D4A4B).withOpacity(0.3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 40,
                color: const Color(0xFF1D4A4B).withOpacity(0.3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF4FC0BD).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Konten utama halaman
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (Tombol kembali dan Judul "Notifikasi")
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: const Color(0xFF1D4A4B),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Notifikasi',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D4A4B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Daftar Notifikasi
                  Expanded(
                    child: Consumer<NotificationController>(
                      builder: (context, controller, child) {
                        if (controller.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (controller.notifications.isEmpty) {
                          return const Center(child: Text('Tidak ada notifikasi saat ini.'));
                        }

                        // === PERUBAHAN UTAMA: Pisahkan notifikasi yang belum dan sudah dibaca ===
                        final unreadNotifications = controller.notifications.where((n) => !n.isRead).toList();
                        final readNotifications = controller.notifications.where((n) => n.isRead).toList();

                        return ListView(
                          children: [
                            // Tampilkan daftar notifikasi yang belum dibaca
                            ...unreadNotifications.map((notification) =>
                                _buildNotificationCard(context, notification, controller)),

                            // === PERUBAHAN UTAMA: Tambahkan pembatas visual ===
                            if (unreadNotifications.isNotEmpty && readNotifications.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Divider(color: Colors.grey[400])),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        "Pesan Terdahulu",
                                        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(child: Divider(color: Colors.grey[400])),
                                  ],
                                ),
                              ),

                            // Tampilkan daftar notifikasi yang sudah dibaca
                            ...readNotifications.map((notification) =>
                                _buildNotificationCard(context, notification, controller)),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === WIDGET BARU: Untuk membangun kartu notifikasi agar lebih rapi ===
  Widget _buildNotificationCard(BuildContext context, NotificationItem notification, NotificationController controller) {
    final formattedTime = DateFormat('dd/MM/yyyy HH:mm').format(notification.timestamp);
    IconData iconData;
    Color iconColor;

    if (notification.type == 'stok_rendah' || notification.type == 'stok_habis') {
      iconData = Icons.warning_amber;
      iconColor = Colors.red[600]!;
    } else {
      iconData = Icons.info_outline;
      iconColor = Colors.blue;
    }

    final bool isRead = notification.isRead;
    final Color cardColor = isRead ? Colors.white : Colors.blue.shade50;
    final FontWeight messageWeight = isRead ? FontWeight.normal : FontWeight.bold;
    final Color messageColor = isRead ? Colors.grey[800]! : Colors.black87;

    return Card(
      color: cardColor,
      elevation: isRead ? 1 : 4,
      margin: const EdgeInsets.only(bottom: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRead ? Colors.grey.shade200 : Colors.blue.shade300,
          width: isRead ? 0.5 : 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(iconData, color: iconColor, size: 28),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.type == 'stok_rendah' ? 'Peringatan Stok' : (notification.type == 'stok_habis' ? 'Stok Habis' : 'Notifikasi'),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1D4A4B)),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        notification.message,
                        style: TextStyle(fontSize: 16, fontWeight: messageWeight, color: messageColor),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formattedTime,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // === PERUBAHAN UTAMA: Tambahkan tombol jika pesan belum dibaca ===
            if (!isRead)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.check_circle_outline, size: 20),
                    label: const Text('Tandai sudah dibaca'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF6A8EEB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      if (notification.id != null) {
                        controller.markNotificationAsRead(notification.id!);
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}