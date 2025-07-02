// lib/services/sqlite_service.dart
import '../models/kategori_model.dart';
import '../models/pengguna_model.dart';
import '../models/barang_model.dart';
import '../models/notification_model.dart'; // Impor model Notifikasi
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
    // UBAH VERSI DATABASE: Jika Anda telah menjalankan aplikasi sebelumnya dan ingin
    // database direset dengan skema baru, ubah 'version: 1' menjadi 'version: 2'
    // atau angka yang lebih tinggi. Kemudian uninstall aplikasi di emulator/perangkat.
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

    await db.execute('''
    CREATE TABLE barang (
      id_barang $idType,
      id_kategori INTEGER,
      nama_barang $textType,
      stok_awal $intType,
      stok_saat_ini $intType,
      harga $realType,
      harga_modal $realType,
      FOREIGN KEY (id_kategori) REFERENCES kategori (id_kategori) ON DELETE SET NULL
    )''');

    await db.execute('''
    CREATE TABLE transaksi (
      id_transaksi $idType,
      id_pengguna INTEGER,
      tanggal $textType,
      jenis_transaksi $textType,
      total $realType,
      FOREIGN KEY (id_pengguna) REFERENCES pengguna (id_pengguna)
    )''');

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

    // UBAH: Tambahkan kolom 'sudah_dibaca' dengan nilai default 0
    await db.execute('''
    CREATE TABLE notifikasi (
      id_notifikasi $idType,
      id_barang INTEGER,
      pesan $textType,
      tipe_notifikasi $textType,
      tanggal $textType,
      sudah_dibaca INTEGER NOT NULL DEFAULT 0, -- BARU: Kolom untuk status dibaca (0=false, 1=true)
      FOREIGN KEY (id_barang) REFERENCES barang (id_barang) ON DELETE SET NULL
    )''');

    await db.rawInsert('''
    INSERT INTO kategori(id_kategori, nama_kategori) VALUES
    (1, 'Makanan'),
    (2, 'Minuman');
  ''');

    // 2. Tambah Barang Dummy
    await db.rawInsert('''
    INSERT INTO barang(id_kategori, nama_barang, stok_awal, stok_saat_ini, harga, harga_modal) VALUES
    (1, 'Kentang Goreng', 20, 20, 8000, 2000),
    (1, 'Nasi Katsu Ayam', 30, 30, 12000, 7000),
    (2, 'Air Mineral', 20, 20, 4000, 2000),
    (2, 'Susu Murni', 30, 30, 5000, 3000);
  ''');
  }

  /// Menyimpan pengguna baru ke dalam tabel 'pengguna'.
  /// Mengembalikan objek Pengguna yang sudah lengkap dengan ID.
  Future<Pengguna> registerUser(Pengguna pengguna) async {
    final db = await instance.database;
    try {
      final id = await db.insert('pengguna', pengguna.toMap());
      return pengguna.copyWith(id: id);
    } catch (e) {
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
    return kategori.copyWith(id: id);
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
        columns: ['id_barang', 'id_kategori', 'nama_barang', 'stok_awal', 'stok_saat_ini', 'harga', 'harga_modal']
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

    await db.transaction((txn) async {
      final idTransaksi = await txn.insert('transaksi', transaksi.toMapWithoutDetails());

      for (final detail in details) {
        await txn.insert('detail_transaksi', detail.toMapWithTransactionId(idTransaksi));

        final barangResult = await txn.query('barang', where: 'id_barang = ?', whereArgs: [detail.idBarang]);

        if (barangResult.isNotEmpty) {
          final barang = Barang.fromMap(barangResult.first);

          if (barang.stokSaatIni < detail.jumlah) {
            throw Exception('Stok untuk ${barang.namaBarang} tidak mencukupi.');
          }

          final stokBaru = barang.stokSaatIni - detail.jumlah;
          await txn.update('barang', {'stok_saat_ini': stokBaru}, where: 'id_barang = ?', whereArgs: [detail.idBarang]);
        } else {
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
  Future<List<Transaksi>> getTransaksiByDateRange(DateTime start, DateTime end) async {
    final db = await instance.database;

    final endDate = end.add(const Duration(days: 1));

    final result = await db.query(
      'transaksi',
      where: 'tanggal >= ? AND tanggal < ?',
      whereArgs: [start.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'tanggal DESC',
    );

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
    List<DetailTransaksi>? details,
  }) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      final barangSaatIni = await txn.query(
        'barang',
        where: 'id_barang = ?',
        whereArgs: [idBarang],
      );

      if (barangSaatIni.isEmpty) {
        throw Exception('Barang tidak ditemukan untuk di-restock.');
      }

      final stokLamaSaatIni = barangSaatIni.first['stok_saat_ini'] as int;
      final stokBaruSaatIni = stokLamaSaatIni + jumlahTambah;
      await txn.update(
        'barang',
        {'stok_saat_ini': stokBaruSaatIni},
        where: 'id_barang = ?',
        whereArgs: [idBarang],
      );

      final idTransaksi = await txn.insert('transaksi', {
        'id_pengguna': idPengguna,
        'tanggal': DateTime.now().toIso8601String(),
        'jenis_transaksi': 'Pembelian',
        'total': totalBiaya,
      });

      if (details != null && details.isNotEmpty) {
        for (final detail in details) {
          await txn.insert('detail_transaksi', detail.toMapWithTransactionId(idTransaksi));
        }
      }
    });
  }

  // UBAH: Metode untuk Notifikasi, pastikan isRead ikut disimpan
  Future<void> createNotification(NotificationItem notification) async {
    final db = await instance.database;
    // Saat membuat notifikasi baru, isRead akan default ke false (0)
    await db.insert('notifikasi', notification.toMap());
  }

  // UBAH: Metode untuk mengambil semua notifikasi, pastikan isRead ikut diambil
  Future<List<NotificationItem>> getAllNotifications() async {
    final db = await instance.database;
    final result = await db.query('notifikasi', orderBy: 'tanggal DESC');
    return result.map((json) => NotificationItem.fromMap(json)).toList();
  }

  // BARU: Metode untuk memperbarui status 'sudah_dibaca' notifikasi
  Future<int> updateNotificationReadStatus(int id, bool isRead) async {
    final db = await instance.database;
    return await db.update(
      'notifikasi',
      {'sudah_dibaca': isRead ? 1 : 0}, // Set 1 jika true, 0 jika false
      where: 'id_notifikasi = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}