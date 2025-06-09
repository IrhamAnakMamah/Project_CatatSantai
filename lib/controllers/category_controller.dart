import 'package:flutter/material.dart';
import '../models/kategori_model.dart';
import '../services/sqlite_service.dart';

class CategoryController extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;

  List<Kategori> _kategoriList = [];
  List<Kategori> get kategoriList => _kategoriList;

  CategoryController() {
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    _kategoriList = await _sqliteService.getAllKategori();
    notifyListeners();
  }

  Future<void> addKategori(String namaKategori) async {
    final kategoriBaru = Kategori(namaKategori: namaKategori);
    await _sqliteService.createKategori(kategoriBaru);
    await fetchKategori(); // Muat ulang daftar setelah menambah
  }
}