class Barang {
  final int? id;
  final String namaBarang;
  final int stokAwal;      // <-- BARU: Stok awal
  final int stokSaatIni;   // <-- UBAH: Menggantikan 'stok' yang lama
  final double harga;
  final double hargaModal;
  final int? idKategori;

  Barang({
    this.id,
    required this.namaBarang,
    required this.stokAwal,      // <-- BARU
    required this.stokSaatIni,   // <-- UBAH
    required this.harga,
    required this.hargaModal,
    this.idKategori,
  });

  Barang copyWith({
    int? id,
    String? namaBarang,
    int? stokAwal,      // <-- BARU
    int? stokSaatIni,   // <-- UBAH
    double? harga,
    double? hargaModal,
    int? idKategori,
  }) {
    return Barang(
      id: id ?? this.id,
      namaBarang: namaBarang ?? this.namaBarang,
      stokAwal: stokAwal ?? this.stokAwal,      // <-- BARU
      stokSaatIni: stokSaatIni ?? this.stokSaatIni, // <-- UBAH
      harga: harga ?? this.harga,
      hargaModal: hargaModal ?? this.hargaModal,
      idKategori: idKategori ?? this.idKategori,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_barang': id,
      'nama_barang': namaBarang,
      'stok_awal': stokAwal,      // <-- BARU
      'stok_saat_ini': stokSaatIni, // <-- UBAH
      'harga': harga,
      'harga_modal': hargaModal,
      'id_kategori': idKategori,
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id_barang'],
      namaBarang: map['nama_barang'],
      stokAwal: map['stok_awal'],      // <-- BARU
      stokSaatIni: map['stok_saat_ini'], // <-- UBAH
      harga: (map['harga'] as num).toDouble(),
      hargaModal: (map['harga_modal'] as num).toDouble(),
      idKategori: map['id_kategori'],
    );
  }
}