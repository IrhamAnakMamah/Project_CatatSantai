class Pengguna {
  final int? id;
  final String nomorTelepon;
  final String password;
  final String? kodeKeamanan;

  Pengguna({
    this.id,
    required this.nomorTelepon,
    required this.password,
    this.kodeKeamanan,
  });

  // Method untuk membuat salinan objek dengan beberapa nilai yang diubah
  Pengguna copyWith({
    int? id,
    String? nomorTelepon,
    String? password,
    String? kodeKeamanan,
  }) =>
      Pengguna(
        id: id ?? this.id,
        nomorTelepon: nomorTelepon ?? this.nomorTelepon,
        password: password ?? this.password,
        kodeKeamanan: kodeKeamanan ?? this.kodeKeamanan,
      );

  // Mengubah objek Pengguna menjadi Map untuk disimpan ke database
  Map<String, dynamic> toMap() {
    return {
      'id_pengguna': id,
      'nomor_telepon': nomorTelepon,
      'password': password,
      'kode_keamanan': kodeKeamanan,
    };
  }

  // Mengubah Map dari database menjadi objek Pengguna
  factory Pengguna.fromMap(Map<String, dynamic> map) {
    return Pengguna(
      id: map['id_pengguna'],
      nomorTelepon: map['nomor_telepon'],
      password: map['password'],
      kodeKeamanan: map['kode_keamanan'],
    );
  }
}