class DetailTransaksi {
  final int? id;
  final int? idTransaksi;
  final int? idBarang; // <--- UBAH INI: Tambahkan tanda tanya (?) agar menjadi nullable
  final int jumlah;
  final double hargaSatuan; // Ini adalah harga jual
  final double subtotal;
  final double keuntungan; // Laba dari penjualan item ini

  DetailTransaksi({
    this.id,
    this.idTransaksi,
    this.idBarang, // <--- UBAH INI: Hapus 'required' jika sebelumnya ada, agar menjadi opsional
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
    required this.keuntungan,
  });

  Map<String, dynamic> toMapWithTransactionId(int transactionId) {
    return {
      'id_detail_transaksi': id,
      'id_transaksi': transactionId,
      'id_barang': idBarang,
      'jumlah': jumlah,
      'harga_satuan': hargaSatuan,
      'subtotal': subtotal,
      'keuntungan': keuntungan,
    };
  }

  factory DetailTransaksi.fromMap(Map<String, dynamic> map) {
    return DetailTransaksi(
      id: map['id_detail_transaksi'],
      idTransaksi: map['id_transaksi'],
      idBarang: map['id_barang'] as int?, // <--- UBAH INI: Pastikan di-cast ke int?
      jumlah: map['jumlah'],
      hargaSatuan: (map['harga_satuan'] as num).toDouble(),
      subtotal: (map['subtotal'] as num).toDouble(),
      keuntungan: (map['keuntungan'] as num).toDouble(),
    );
  }
}