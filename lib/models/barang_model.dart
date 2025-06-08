class Barang {
  final int? id;
  final String namaBarang;
  final int stok;
  final double harga;
  final int? idKategori;

  Barang({
    this.id,
    required this.namaBarang,
    required this.stok,
    required this.harga,
    this.idKategori,
  });

  Barang copyWith({
    int? id,
    String? namaBarang,
    int? stok,
    double? harga,
    int? idKategori,
  }) =>
      Barang(
        id: id ?? this.id,
        namaBarang: namaBarang ?? this.namaBarang,
        stok: stok ?? this.stok,
        harga: harga ?? this.harga,
        idKategori: idKategori ?? this.idKategori,
      );

  Map<String, dynamic> toMap() {
    return {
      'id_barang': id,
      'nama_barang': namaBarang,
      'stok': stok,
      'harga': harga,
      'id_kategori': idKategori,
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id_barang'],
      namaBarang: map['nama_barang'],
      stok: map['stok'],
      harga: map['harga'].toDouble(), // Pastikan konversi ke double
      idKategori: map['id_kategori'],
    );
  }
}