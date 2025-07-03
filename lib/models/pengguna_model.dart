class Pengguna {
  final int? id;
  final String nomorTelepon;
  final String password;
  final String? kodeKeamanan;
  final bool sudahIsiProfil; // Tipe data ini sudah benar (bool)

  Pengguna({
    this.id,
    required this.nomorTelepon,
    required this.password,
    this.kodeKeamanan,
    this.sudahIsiProfil = false, // Nilai default adalah false
  });

  Pengguna copyWith({
    int? id,
    String? nomorTelepon,
    String? password,
    String? kodeKeamanan,
    bool? sudahIsiProfil,
  }) {
    return Pengguna(
      id: id ?? this.id,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      password: password ?? this.password,
      kodeKeamanan: kodeKeamanan ?? this.kodeKeamanan,
      sudahIsiProfil: sudahIsiProfil ?? this.sudahIsiProfil,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_pengguna': id,
      'nomor_telepon': nomorTelepon,
      'password': password,
      'kode_keamanan': kodeKeamanan,
      // Saat menyimpan ke DB, ubah bool menjadi integer (0 atau 1)
      'sudah_isi_profil': sudahIsiProfil ? 1 : 0,
    };
  }

  factory Pengguna.fromMap(Map<String, dynamic> map) {
    return Pengguna(
      id: map['id_pengguna'],
      nomorTelepon: map['nomor_telepon'],
      password: map['password'],
      kodeKeamanan: map['kode_keamanan'],
      // === PERBAIKAN UTAMA DI SINI ===
      // Saat membaca dari DB, ubah integer menjadi bool.
      // `map['sudah_isi_profil'] == 1` akan menghasilkan true jika nilainya 1, dan false jika nilainya 0.
      sudahIsiProfil: map['sudah_isi_profil'] == 1,
    );
  }
}