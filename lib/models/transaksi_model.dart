import 'package:catatsantai/models/detail_transaksi_model.dart'; // Pastikan import detail

class Transaksi {
  final int? id;
  final int idPengguna;
  final DateTime tanggal;
  final String jenisTransaksi; // "Penjualan" atau "Pembelian"
  final double total;
  final List<DetailTransaksi> details; // Untuk menampung detailnya

  Transaksi({
    this.id,
    required this.idPengguna,
    required this.tanggal,
    required this.jenisTransaksi,
    required this.total,
    this.details = const [], // Defaultnya list kosong
  });

  // Map untuk menyimpan ke DB, tanpa detail. Detail disimpan terpisah.
  Map<String, dynamic> toMapWithoutDetails() {
    return {
      'id_transaksi': id,
      'id_pengguna': idPengguna,
      'tanggal': tanggal.toIso8601String(), // Simpan tanggal sebagai teks ISO 8601
      'jenis_transaksi': jenisTransaksi,
      'total': total,
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map, List<DetailTransaksi> details) {
    return Transaksi(
      id: map['id_transaksi'],
      idPengguna: map['id_pengguna'],
      tanggal: DateTime.parse(map['tanggal']), // Ubah kembali teks ke DateTime
      jenisTransaksi: map['jenis_transaksi'],
      total: map['total'].toDouble(),
      details: details,
    );
  }
}