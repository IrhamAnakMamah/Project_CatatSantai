import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catatsantai/controllers/category_controller.dart';
import 'package:catatsantai/controllers/stock_controller.dart';
import 'package:catatsantai/models/barang_model.dart';
import 'package:catatsantai/models/kategori_model.dart';

Future<void> populateDummyData(BuildContext context) async {
  final categoryController = Provider.of<CategoryController>(context, listen: false);
  final stockController = Provider.of<StockController>(context, listen: false);

  // --- LOGIKA PENCEGAHAN DUPLIKASI DATA ---
  await categoryController.fetchKategori();
  bool makananExists = categoryController.kategoriList.any((k) => k.namaKategori == 'Makanan');
  bool minumanExists = categoryController.kategoriList.any((k) => k.namaKategori == 'Minuman');

  await stockController.fetchBarang();
  bool itemsExist = stockController.barangList.isNotEmpty;

  if (makananExists && minumanExists && itemsExist) {
    print('Dummy data sepertinya sudah ada. Melewatkan pengisian data.');
    return;
  }
  // --- AKHIR LOGIKA PENCEGAHAN DUPLIKASI DATA ---


  print('Memulai pengisian dummy data...');

  int? makananId;
  int? minumanId;

  try {
    if (!makananExists) {
      print('Menambahkan kategori: Makanan');
      await categoryController.addKategori('Makanan');
    }
    if (!minumanExists) {
      print('Menambahkan kategori: Minuman');
      await categoryController.addKategori('Minuman');
    }
    await categoryController.fetchKategori(); // Refresh categories after adding
    for (var k in categoryController.kategoriList) {
      if (k.namaKategori == 'Makanan') {
        makananId = k.id;
      } else if (k.namaKategori == 'Minuman') {
        minumanId = k.id;
      }
    }
    print('ID Kategori ditemukan: Makanan=$makananId, Minuman=$minumanId');
  } catch (e) {
    print('Error saat menambahkan kategori atau mendapatkan ID: $e');
    return; // Hentikan jika ada error pada kategori
  }


  if (makananId == null || minumanId == null) {
    print('Gagal mendapatkan ID kategori yang valid. Tidak dapat menambahkan barang.');
    return;
  }

  // Tambahkan Barang hanya jika daftar barang masih kosong
  if (!itemsExist) {
    print('Daftar barang kosong, mulai menambahkan barang dummy.');
    try {
      print('Menambahkan Kentang Goreng...');
      await stockController.addBarang(context, Barang(
        namaBarang: 'Kentang Goreng',
        stokAwal: 20,
        stokSaatIni: 20,
        hargaModal: 2000,
        harga: 8000,
        idKategori: makananId,
      ));
      print('Kentang Goreng berhasil ditambahkan. Jumlah barang saat ini: ${stockController.barangList.length}');

      print('Menambahkan Nasi Katsu Ayam...');
      await stockController.addBarang(context, Barang(
        namaBarang: 'Nasi Katsu Ayam',
        stokAwal: 30,
        stokSaatIni: 30,
        hargaModal: 7000,
        harga: 12000,
        idKategori: makananId,
      ));
      print('Nasi Katsu Ayam berhasil ditambahkan. Jumlah barang saat ini: ${stockController.barangList.length}');

      print('Menambahkan Air Mineral...');
      await stockController.addBarang(context, Barang(
        namaBarang: 'Air Mineral',
        stokAwal: 20,
        stokSaatIni: 20,
        hargaModal: 2000,
        harga: 4000,
        idKategori: minumanId,
      ));
      print('Air Mineral berhasil ditambahkan. Jumlah barang saat ini: ${stockController.barangList.length}');

      print('Menambahkan Susu Murni...');
      await stockController.addBarang(context, Barang(
        namaBarang: 'Susu Murni',
        stokAwal: 30,
        stokSaatIni: 30,
        hargaModal: 3000,
        harga: 5000,
        idKategori: minumanId,
      ));
      print('Susu Murni berhasil ditambahkan. Jumlah barang saat ini: ${stockController.barangList.length}');

      print('Semua barang dummy berhasil ditambahkan.');

    } catch (e) {
      print('Error saat menambahkan barang dummy: $e');
    }
  } else {
    print('Daftar barang sudah terisi. Melewatkan penambahan barang.');
  }

  print('Pengisian dummy data selesai!');
}