class DetailTransaksi {
  final int? id;
  final int? idTransaksi;
  final int idBarang;
  final int jumlah;
  final double hargaSatuan; // Ini adalah harga jual
  final double subtotal;
  // --- PENAMBAHAN BARU ---
  final double keuntungan; // Laba dari penjualan item ini
  // -----------------------

  DetailTransaksi({
    this.id,
    this.idTransaksi,
    required this.idBarang,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
    // --- PENAMBAHAN BARU ---
    required this.keuntungan,
    // -----------------------
  });

  Map<String, dynamic> toMapWithTransactionId(int transactionId) {
    return {
      'id_detail_transaksi': id,
      'id_transaksi': transactionId,
      'id_barang': idBarang,
      'jumlah': jumlah,
      'harga_satuan': hargaSatuan,
      'subtotal': subtotal,
      'keuntungan': keuntungan, // --- PENAMBAHAN BARU ---
    };
  }

  factory DetailTransaksi.fromMap(Map<String, dynamic> map) {
    return DetailTransaksi(
      id: map['id_detail_transaksi'],
      idTransaksi: map['id_transaksi'],
      idBarang: map['id_barang'],
      jumlah: map['jumlah'],
      hargaSatuan: (map['harga_satuan'] as num).toDouble(),
      subtotal: (map['subtotal'] as num).toDouble(),
      keuntungan: (map['keuntungan'] as num).toDouble(), // --- PENAMBAHAN BARU ---
    );
  }
}
