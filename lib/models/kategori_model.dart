class Kategori {
  final int? id;
  final String namaKategori;

  Kategori({
    this.id,
    required this.namaKategori,
  });

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
}