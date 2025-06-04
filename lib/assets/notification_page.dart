import 'package:flutter/material.dart';

// Class untuk merepresentasikan satu item notifikasi
class NotificationItem {
  final String title;
  final String message;
  final String timestamp;

  const NotificationItem({required this.title, required this.message, required this.timestamp}); // Tambahkan const di constructor
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  // Contoh data notifikasi
  // Pastikan setiap NotificationItem juga menggunakan 'const'
  final List<NotificationItem> _notifications = const [
    const NotificationItem( // Tambahkan const di sini
      title: 'Peringatan',
      message: 'Data stok daging menipis !',
      timestamp: 'Hari ini 9:41',
    ),
    const NotificationItem( // Tambahkan const di sini
      title: 'Peringatan',
      message: 'Data stok daging menipis !',
      timestamp: 'Kemarin 9:41',
    ),
    const NotificationItem( // Tambahkan const di sini
      title: 'Peringatan',
      message: 'Data stok daging menipis !',
      timestamp: '26/11/2024 9:41',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background halaman, mirip dengan warna di design Figma
      backgroundColor: const Color(0xFFF7F5EC), // Warna krem muda
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
                color: const Color(0xFF4FC0BD).withOpacity(0.8), // Tosca
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
                color: const Color(0xFF1D4A4B).withOpacity(0.3), // Darker tosca, semi-transparent
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
                color: const Color(0xFF4FC0BD).withOpacity(0.5), // Tosca, semi-transparent
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Konten utama halaman
          SafeArea( // Untuk menghindari overlap dengan status bar
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
                children: [
                  // Header (Tombol kembali dan Judul "Notifikasi")
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Kembali ke halaman sebelumnya
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.8), // Warna putih transparan
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new, // Icon panah ke kiri
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
                          color: const Color(0xFF1D4A4B), // Warna teks gelap
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Daftar Notifikasi
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero, // Hilangkan padding default ListView
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.warning_amber, // Icon peringatan
                                    color: Colors.red[600],
                                    size: 28,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.title,
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
                                          notification.timestamp,
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
                              const Divider(height: 30, thickness: 0.8, color: Colors.grey), // Divider antar notifikasi
                            ],
                          ),
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
