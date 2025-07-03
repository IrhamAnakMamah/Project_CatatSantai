class ProfilUsaha {
  final int? idProfilUsaha;
  final int idPengguna;
  final String namaUsaha;
  final String? alamat;

  ProfilUsaha({
    this.idProfilUsaha,
    required this.idPengguna,
    required this.namaUsaha,
    this.alamat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_profil_usaha': idProfilUsaha,
      'id_pengguna': idPengguna,
      'nama_usaha': namaUsaha,
      'alamat': alamat,
    };
  }

  factory ProfilUsaha.fromMap(Map<String, dynamic> map) {
    return ProfilUsaha(
      idProfilUsaha: map['id_profil_usaha'],
      idPengguna: map['id_pengguna'],
      namaUsaha: map['nama_usaha'],
      alamat: map['alamat'],
    );
  }
}