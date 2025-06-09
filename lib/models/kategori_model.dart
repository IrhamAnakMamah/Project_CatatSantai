class Kategori {
  final int? id;
  final String namaKategori;

  Kategori({
    this.id,
    required this.namaKategori,
  });

  Kategori copyWith({
    int? id,
    String? namaKategori,
  }) {
    return Kategori(
      id: id ?? this.id,
      namaKategori: namaKategori ?? this.namaKategori,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_kategori': id,
      'nama_kategori': namaKategori,
    };
  }

  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(
      id: map['id_kategori'],
      namaKategori: map['nama_kategori'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Kategori && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
