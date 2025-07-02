import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../../controllers/notification_controller.dart'; // Impor NotificationController
import '../../models/notification_model.dart'; // Impor NotificationItem

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menghapus data dummy yang lama
    // final List<NotificationItem> _notifications = const [...];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: Stack(
        children: [
          // Background shapes (lingkaran dan tanda plus) - konsisten dengan halaman sebelumnya
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

                  // Daftar Notifikasi (Sekarang dari NotificationController)
                  Expanded(
                    child: Consumer<NotificationController>( // Menggunakan Consumer
                      builder: (context, notificationController, child) {
                        if (notificationController.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (notificationController.notifications.isEmpty) {
                          return const Center(child: Text('Tidak ada notifikasi saat ini.'));
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: notificationController.notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notificationController.notifications[index];
                            final String formattedTime = DateFormat('dd/MM/yyyy HH:mm').format(notification.timestamp);
                            IconData iconData;
                            Color iconColor;

                            // Menentukan ikon dan warna berdasarkan tipe notifikasi
                            if (notification.type == 'stok_rendah' || notification.type == 'stok_habis') {
                              iconData = Icons.warning_amber;
                              iconColor = Colors.red[600]!;
                            } else {
                              iconData = Icons.info_outline; // Default
                              iconColor = Colors.blue;      // Default
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        iconData, // Ikon dinamis
                                        color: iconColor, // Warna ikon dinamis
                                        size: 28,
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notification.type == 'stok_rendah' ? 'Peringatan Stok' : (notification.type == 'stok_habis' ? 'Stok Habis' : 'Notifikasi'), // Judul dinamis
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF1D4A4B),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              notification.message,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              formattedTime, // Tanggal dinamis
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 30, thickness: 0.8, color: Colors.grey),
                                ],
                              ),
                            );
                          },
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
}