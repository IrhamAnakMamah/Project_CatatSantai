import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../../controllers/notification_controller.dart'; // Impor NotificationController
import '../../models/notification_model.dart'; // Impor NotificationItem

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
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

                  // Daftar Notifikasi
                  Expanded(
                    child: Consumer<NotificationController>(
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

                            // BARU: Menentukan gaya berdasarkan status dibaca/belum dibaca
                            final bool isRead = notification.isRead;
                            // Warna latar belakang yang berbeda untuk notifikasi belum dibaca
                            final Color cardColor = isRead ? Colors.white : Colors.blue.shade50;
                            // Ketebalan teks pesan yang berbeda
                            final FontWeight messageWeight = isRead ? FontWeight.normal : FontWeight.bold;
                            // Warna teks pesan yang berbeda
                            final Color messageColor = isRead ? Colors.grey[700]! : Colors.black87;

                            return GestureDetector( // BARU: Menambahkan GestureDetector agar notifikasi bisa diketuk
                              onTap: () {
                                // Tandai notifikasi sebagai sudah dibaca hanya jika belum dibaca
                                if (!isRead && notification.id != null) {
                                  notificationController.markNotificationAsRead(notification.id!);
                                }
                              },
                              child: Card( // BARU: Bungkus dengan Card untuk visualisasi yang lebih baik
                                color: cardColor, // Menggunakan warna dinamis
                                elevation: isRead ? 1 : 3, // Lebih menonjol jika belum dibaca
                                margin: const EdgeInsets.only(bottom: 15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isRead ? Colors.grey.shade200 : Colors.blue.shade200, // Border untuk belum dibaca
                                    width: isRead ? 0.5 : 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
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
                                                fontWeight: messageWeight, // BARU: FontWeight dinamis
                                                color: messageColor, // BARU: Warna teks dinamis
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
                                ),
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