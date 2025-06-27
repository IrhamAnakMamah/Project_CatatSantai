// lib/services/sqlite_service.dart
import '../models/kategori_model.dart';
import '../models/pengguna_model.dart';
import '../models/barang_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaksi_model.dart';
import '../models/detail_transaksi_model.dart';

class SqliteService {
  static final SqliteService instance = SqliteService._init();
  static Database? _database;
  SqliteService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('catat_santai.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // Kita akan menaikkan versi database ke 2. Ini akan memicu onUpgrade.
    // Namun, cara termudah selama pengembangan adalah uninstall aplikasi.
    return await openDatabase(path, version: 1, onCreate: _createDB, onConfigure: _onConfigure);
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // ... (CREATE TABLE untuk pengguna, profil_usaha, kategori tidak berubah)
    await db.execute('''
    CREATE TABLE pengguna (
      id_pengguna $idType,
      nomor_telepon TEXT NOT NULL UNIQUE,
      password $textType,
      kode_keamanan TEXT
    )''');
    await db.execute('''
    CREATE TABLE profil_usaha (
      id_profil_usaha $idType,
      id_pengguna INTEGER UNIQUE,
      nama_usaha $textType,
      alamat TEXT,
      FOREIGN KEY (id_pengguna) REFERENCES pengguna (id_pengguna) ON DELETE CASCADE
    )''');
    await db.execute('''
    CREATE TABLE kategori (
      id_kategori $idType,
      nama_kategori $textType UNIQUE
    )''');


    // --- PERUBAHAN SKEMA TABEL BARANG ---
    await db.execute('''
    CREATE TABLE barang (
      id_barang $idType,
      id_kategori INTEGER,
      nama_barang $textType,
      stok $intType,
      harga $realType,
      harga_modal $realType,
      FOREIGN KEY (id_kategori) REFERENCES kategori (id_kategori) ON DELETE SET NULL
    )''');

    // ... (CREATE TABLE untuk transaksi tidak berubah)
    await db.execute('''
    CREATE TABLE transaksi (
      id_transaksi $idType,
      id_pengguna INTEGER,
      tanggal $textType,
      jenis_transaksi $textType,
      total $realType,
      FOREIGN KEY (id_pengguna) REFERENCES pengguna (id_pengguna)
    )''');

    // --- PERUBAHAN SKEMA TABEL DETAIL TRANSAKSI ---
    await db.execute('''
    CREATE TABLE detail_transaksi (
      id_detail_transaksi $idType,
      id_transaksi INTEGER,
      id_barang INTEGER,
      jumlah $intType,
      harga_satuan $realType,
      subtotal $realType,
      keuntungan $realType,
      FOREIGN KEY (id_transaksi) REFERENCES transaksi (id_transaksi) ON DELETE CASCADE,
      FOREIGN KEY (id_barang) REFERENCES barang (id_barang) ON DELETE SET NULL
    )''');
  }

  /// Menyimpan pengguna baru ke dalam tabel 'pengguna'.
  /// Mengembalikan objek Pengguna yang sudah lengkap dengan ID.
  Future<Pengguna> registerUser(Pengguna pengguna) async {
    final db = await instance.database;
    try {
      final id = await db.insert('pengguna', pengguna.toMap());
      return pengguna.copyWith(id: id);
    } catch (e) {
      // Kemungkinan besar error terjadi karena UNIQUE constraint pada nomor_telepon.
      print("Error saat registerUser: $e");
      rethrow;
    }
  }

  /// Mencari pengguna di database berdasarkan nomor telepon.
  /// Mengembalikan objek Pengguna jika ditemukan, atau null jika tidak.
  Future<Pengguna?> getUserByPhone(String phone) async {
    final db = await instance.database;
    final maps = await db.query(
      'pengguna',
      columns: ['id_pengguna', 'nomor_telepon', 'password', 'kode_keamanan'],
      where: 'nomor_telepon = ?',
      whereArgs: [phone],
    );

    if (maps.isNotEmpty) {
      return Pengguna.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /// Menyimpan kategori baru.
  Future<Kategori> createKategori(Kategori kategori) async {
    final db = await instance.database;
    final id = await db.insert('kategori', kategori.toMap());
    return kategori.copyWith(id: id); // Anda perlu menambahkan copyWith di model Kategori
  }

  /// Mengambil semua kategori.
  Future<List<Kategori>> getAllKategori() async {
    final db = await instance.database;
    final result = await db.query('kategori', orderBy: 'nama_kategori ASC');
    return result.map((json) => Kategori.fromMap(json)).toList();
  }

  /// Menyimpan barang baru ke dalam tabel 'barang'.
  Future<Barang> createBarang(Barang barang) async {
    final db = await instance.database;
    final id = await db.insert('barang', barang.toMap());
    return barang.copyWith(id: id);
  }

  /// Mengambil satu barang spesifik berdasarkan ID-nya.
  Future<Barang> getBarangById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'barang',
      where: 'id_barang = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Barang.fromMap(maps.first);
    } else {
      throw Exception('ID $id tidak ditemukan di database');
    }
  }

  /// Mengambil semua barang dari database, diurutkan berdasarkan nama.
  Future<List<Barang>> getAllBarang() async {
    final db = await instance.database;
    final result = await db.query('barang', orderBy: 'nama_barang ASC');
    return result.map((json) => Barang.fromMap(json)).toList();
  }

  /// Memperbarui data barang yang ada di database.
  Future<int> updateBarang(Barang barang) async {
    final db = await instance.database;
    return db.update(
      'barang',
      barang.toMap(),
      where: 'id_barang = ?',
      whereArgs: [barang.id],
    );
  }

  /// Menghapus barang dari database berdasarkan ID-nya.
  Future<int> deleteBarang(int id) async {
    final db = await instance.database;
    return await db.delete(
      'barang',
      where: 'id_barang = ?',
      whereArgs: [id],
    );
  }

  /// Menyimpan transaksi baru dan mengupdate stok barang secara atomik.
  Future<void> createTransaksi(Transaksi transaksi, List<DetailTransaksi> details) async {
    final db = await instance.database;

    // Gunakan db.transaction untuk memastikan semua operasi berhasil atau semuanya dibatalkan
    await db.transaction((txn) async {
      // 1. Simpan header transaksi dan dapatkan ID-nya
      final idTransaksi = await txn.insert('transaksi', transaksi.toMapWithoutDetails());

      // 2. Loop melalui setiap detail barang dalam transaksi
      for (final detail in details) {
        // 3. Simpan detail transaksi dengan ID header yang baru saja didapat
        await txn.insert('detail_transaksi', detail.toMapWithTransactionId(idTransaksi));

        // 4. Ambil data barang saat ini untuk mendapatkan stok terakhir
        final barangResult = await txn.query('barang', where: 'id_barang = ?', whereArgs: [detail.idBarang]);

        if (barangResult.isNotEmpty) {
          final barang = Barang.fromMap(barangResult.first);

          // Error handling: Pastikan stok cukup sebelum mengurangi
          if (barang.stok < detail.jumlah) {
            // Jika stok tidak cukup, batalkan seluruh transaksi dengan melempar error
            throw Exception('Stok untuk ${barang.namaBarang} tidak mencukupi.');
          }

          final stokBaru = barang.stok - detail.jumlah;
          // 5. Update stok barang di database
          await txn.update('barang', {'stok': stokBaru}, where: 'id_barang = ?', whereArgs: [detail.idBarang]);
        } else {
          // Jika karena suatu alasan barang tidak ditemukan, batalkan transaksi
          throw Exception('Barang dengan ID ${detail.idBarang} tidak ditemukan.');
        }
      }
    });
  }

  /// Mengambil semua transaksi dari database (untuk halaman laporan nanti).
  Future<List<Transaksi>> getAllTransaksi() async {
    final db = await instance.database;
    final result = await db.query('transaksi', orderBy: 'tanggal DESC');

    List<Transaksi> transaksiList = [];
    for (var trxMap in result) {
      final detailResult = await db.query(
        'detail_transaksi',
        where: 'id_transaksi = ?',
        whereArgs: [trxMap['id_transaksi']],
      );
      final details = detailResult.map((json) => DetailTransaksi.fromMap(json)).toList();
      transaksiList.add(Transaksi.fromMap(trxMap, details));
    }
    return transaksiList;
  }

  /// Mengambil semua transaksi dalam rentang tanggal tertentu.
  /// Tanggal disimpan sebagai teks dalam format ISO 8601, jadi kita bisa membandingkannya sebagai string.
  Future<List<Transaksi>> getTransaksiByDateRange(DateTime start, DateTime end) async {
    final db = await instance.database;

    // Menambahkan satu hari ke tanggal akhir untuk memastikan semua transaksi
    // pada hari 'end' ikut terambil (karena perbandingan waktunya hingga 23:59:59).
    final endDate = end.add(const Duration(days: 1));

    final result = await db.query(
      'transaksi',
      where: 'tanggal >= ? AND tanggal < ?',
      whereArgs: [start.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'tanggal DESC',
    );

    // Proses ini sama seperti di getAllTransaksi, yaitu mengambil detail
    // untuk setiap transaksi yang ditemukan.
    List<Transaksi> transaksiList = [];
    for (var trxMap in result) {
      final detailResult = await db.query(
        'detail_transaksi',
        where: 'id_transaksi = ?',
        whereArgs: [trxMap['id_transaksi']],
      );
      final details = detailResult.map((json) => DetailTransaksi.fromMap(json)).toList();
      transaksiList.add(Transaksi.fromMap(trxMap, details));
    }
    return transaksiList;
  }

  Future<void> createPembelian({
    required int idBarang,
    required int jumlahTambah,
    required double totalBiaya,
    required int idPengguna,
  }) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      // 1. Ambil data barang saat ini untuk mendapatkan stok terakhir
      final barangSaatIni = await txn.query(
        'barang',
        where: 'id_barang = ?',
        whereArgs: [idBarang],
      );

      if (barangSaatIni.isEmpty) {
        throw Exception('Barang tidak ditemukan untuk di-restock.');
      }

      // 2. Hitung stok baru dan update ke database
      final stokLama = barangSaatIni.first['stok'] as int;
      final stokBaru = stokLama + jumlahTambah;
      await txn.update(
        'barang',
        {'stok': stokBaru},
        where: 'id_barang = ?',
        whereArgs: [idBarang],
      );

      // 3. Buat catatan transaksi baru untuk pengeluaran
      await txn.insert('transaksi', {
        'id_pengguna': idPengguna,
        'tanggal': DateTime.now().toIso8601String(),
        'jenis_transaksi': 'Pembelian',
        'total': totalBiaya,
      });
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}