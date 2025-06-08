class DetailTransaksi {
  final int? id;
  final int? idTransaksi; // Akan diisi saat menyimpan
  final int idBarang;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;

  DetailTransaksi({
    this.id,
    this.idTransaksi,
    required this.idBarang,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
  });

  // Map untuk menyimpan ke DB
  Map<String, dynamic> toMapWithTransactionId(int transactionId) {
    return {
      'id_detail_transaksi': id,
      'id_transaksi': transactionId, // Gunakan ID dari header transaksi
      'id_barang': idBarang,
      'jumlah': jumlah,
      'harga_satuan': hargaSatuan,
      'subtotal': subtotal,
    };
  }

  factory DetailTransaksi.fromMap(Map<String, dynamic> map) {
    return DetailTransaksi(
      id: map['id_detail_transaksi'],
      idTransaksi: map['id_transaksi'],
      idBarang: map['id_barang'],
      jumlah: map['jumlah'],
      hargaSatuan: map['harga_satuan'].toDouble(),
      subtotal: map['subtotal'].toDouble(),
    );
  }
}