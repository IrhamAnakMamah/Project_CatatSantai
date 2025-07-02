// lib/models/notification_model.dart
class NotificationItem {
  final int? id;
  final int? idBarang; // Bisa null jika notifikasi tidak terkait barang
  final String message;
  final String type; // e.g., 'stok_rendah', 'umum'
  final DateTime timestamp;

  NotificationItem({
    this.id,
    this.idBarang,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_notifikasi': id,
      'id_barang': idBarang,
      'pesan': message,
      'tipe_notifikasi': type,
      'tanggal': timestamp.toIso8601String(), // Simpan tanggal sebagai teks ISO 8601
    };
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id_notifikasi'],
      idBarang: map['id_barang'] as int?,
      message: map['pesan'],
      type: map['tipe_notifikasi'],
      timestamp: DateTime.parse(map['tanggal']),
    );
  }
}