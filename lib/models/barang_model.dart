class Barang {
  final int? id;
  final String namaBarang;
  final int stok;
  final double harga;
  // --- PENAMBAHAN BARU ---
  final double hargaModal; // Harga beli atau modal per item
  // -----------------------
  final int? idKategori;

  Barang({
    this.id,
    required this.namaBarang,
    required this.stok,
    required this.harga,
    // --- PENAMBAHAN BARU ---
    required this.hargaModal,
    // -----------------------
    this.idKategori,
  });

  Barang copyWith({
    int? id,
    String? namaBarang,
    int? stok,
    double? harga,
    double? hargaModal, // --- PENAMBAHAN BARU ---
    int? idKategori,
  }) {
    return Barang(
      id: id ?? this.id,
      namaBarang: namaBarang ?? this.namaBarang,
      stok: stok ?? this.stok,
      harga: harga ?? this.harga,
      hargaModal: hargaModal ?? this.hargaModal, // --- PENAMBAHAN BARU ---
      idKategori: idKategori ?? this.idKategori,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_barang': id,
      'nama_barang': namaBarang,
      'stok': stok,
      'harga': harga,
      'harga_modal': hargaModal, // --- PENAMBAHAN BARU ---
      'id_kategori': idKategori,
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id_barang'],
      namaBarang: map['nama_barang'],
      stok: map['stok'],
      harga: (map['harga'] as num).toDouble(),
      hargaModal: (map['harga_modal'] as num).toDouble(), // --- PENAMBAHAN BARU ---
      idKategori: map['id_kategori'],
    );
  }
}
