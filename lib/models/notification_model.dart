// lib/models/notification_model.dart
class NotificationItem {
  final int? id;
  final int? idBarang; // Bisa null jika notifikasi tidak terkait barang
  final String message;
  final String type; // e.g., 'stok_rendah', 'umum'
  final DateTime timestamp;
  final bool isRead; // BARU: Tambahkan properti ini

  NotificationItem({
    this.id,
    this.idBarang,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false, // BARU: Default ke false (belum dibaca)
  });

  Map<String, dynamic> toMap() {
    return {
      'id_notifikasi': id,
      'id_barang': idBarang,
      'pesan': message,
      'tipe_notifikasi': type,
      'tanggal': timestamp.toIso8601String(), // Simpan tanggal sebagai teks ISO 8601
      'sudah_dibaca': isRead ? 1 : 0, // BARU: Simpan sebagai integer (1=true, 0=false)
    };
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id_notifikasi'],
      idBarang: map['id_barang'] as int?,
      message: map['pesan'],
      type: map['tipe_notifikasi'],
      timestamp: DateTime.parse(map['tanggal']),
      isRead: map['sudah_dibaca'] == 1, // BARU: Konversi integer ke boolean
    );
  }

  // BARU: Tambahkan copyWith untuk memudahkan update status tanpa mengubah objek asli
  NotificationItem copyWith({
    int? id,
    int? idBarang,
    String? message,
    String? type,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      idBarang: idBarang ?? this.idBarang,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}