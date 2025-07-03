class Barang {
  final int? id;
  final String namaBarang;
  final int stokAwal;
  final int stokSaatIni;
  final double harga;
  final double hargaModal;
  final int? idKategori;

  Barang({
    this.id,
    required this.namaBarang,
    required this.stokAwal,
    required this.stokSaatIni,
    required this.harga,
    required this.hargaModal,
    this.idKategori,
  });

  Barang copyWith({
    int? id,
    String? namaBarang,
    int? stokAwal,
    int? stokSaatIni,
    double? harga,
    double? hargaModal,
    int? idKategori,
  }) {
    return Barang(
      id: id ?? this.id,
      namaBarang: namaBarang ?? this.namaBarang,
      stokAwal: stokAwal ?? this.stokAwal,
      stokSaatIni: stokSaatIni ?? this.stokSaatIni,
      harga: harga ?? this.harga,
      hargaModal: hargaModal ?? this.hargaModal,
      idKategori: idKategori ?? this.idKategori,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_barang': id,
      'nama_barang': namaBarang,
      'stok_awal': stokAwal,
      'stok_saat_ini': stokSaatIni,
      'harga': harga,
      'harga_modal': hargaModal,
      'id_kategori': idKategori,
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id_barang'],
      namaBarang: map['nama_barang'],
      // PERBAIKAN DI SINI: Gunakan 'as int? ?? 0' untuk menangani null dari DB lama
      stokAwal: map['stok_awal'] as int? ?? 0,
      stokSaatIni: map['stok_saat_ini'] as int? ?? 0,
      harga: (map['harga'] as num).toDouble(),
      hargaModal: (map['harga_modal'] as num).toDouble(),
      idKategori: map['id_kategori'],
    );
  }
}