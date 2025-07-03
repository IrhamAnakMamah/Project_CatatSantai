class DetailTransaksi {
  final int? id;
  final int? idTransaksi;
  final int? idBarang;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;
  final double keuntungan;
  final String? namaBarang; // BARU: Pastikan properti ini ada

  DetailTransaksi({
    this.id,
    this.idTransaksi,
    this.idBarang,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
    required this.keuntungan,
    this.namaBarang, // BARU: Tambahkan di constructor
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
      idBarang: map['id_barang'] as int?,
      jumlah: map['jumlah'],
      hargaSatuan: (map['harga_satuan'] as num).toDouble(),
      subtotal: (map['subtotal'] as num).toDouble(),
      keuntungan: (map['keuntungan'] as num).toDouble(),
      // BARU: Ambil 'nama_barang' dari hasil query JOIN
      namaBarang: map['nama_barang'] as String?,
    );
  }
}