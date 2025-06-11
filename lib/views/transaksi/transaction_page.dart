import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../controllers/category_controller.dart'; // 1. Impor CategoryController
import '../../models/barang_model.dart';
import '../../models/kategori_model.dart'; // 2. Impor model Kategori

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  // Map untuk menyimpan jumlah barang yang dipilih oleh pengguna
  final Map<int, int> _selectedItems = {};
  String _searchQuery = '';
  Kategori? _selectedKategoriFilter; // 3. State baru untuk filter kategori

  @override
  void initState() {
    super.initState();
    // Memastikan data stok dan kategori dimuat saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StockController>(context, listen: false).fetchBarang();
      Provider.of<CategoryController>(context, listen: false).fetchKategori();
    });
  }

  void _incrementQuantity(int barangId) {
    setState(() {
      _selectedItems[barangId] = (_selectedItems[barangId] ?? 0) + 1;
    });
  }

  void _decrementQuantity(int barangId) {
    setState(() {
      if (_selectedItems.containsKey(barangId)) {
        if (_selectedItems[barangId]! > 1) {
          _selectedItems[barangId] = _selectedItems[barangId]! - 1;
        } else {
          _selectedItems.remove(barangId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      appBar: AppBar(
        title: Text(
          'Catat Transaksi',
          style: TextStyle(color: const Color(0xFF1D4A4B), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Widget untuk filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // 4. Filter berdasarkan nama barang
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Cari nama barang...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // 5. Filter berdasarkan kategori
                Consumer<CategoryController>(
                  builder: (context, categoryController, child) {
                    return DropdownButton<Kategori>(
                      value: _selectedKategoriFilter,
                      hint: Text('Kategori'),
                      icon: Icon(Icons.filter_list),
                      underline: SizedBox(), // Menghilangkan garis bawah
                      items: [
                        // Opsi untuk menampilkan semua kategori
                        DropdownMenuItem<Kategori>(
                          value: null,
                          child: Text('Semua Kategori'),
                        ),
                        // Daftar kategori dari database
                        ...categoryController.kategoriList.map((kategori) {
                          return DropdownMenuItem<Kategori>(
                            value: kategori,
                            child: Text(kategori.namaKategori),
                          );
                        }).toList(),
                      ],
                      onChanged: (kategori) {
                        setState(() {
                          _selectedKategoriFilter = kategori;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Daftar Barang
          Expanded(
            child: Consumer<StockController>(
              builder: (context, stockController, child) {
                if (stockController.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 6. Logika filter diperbarui
                final displayedList = stockController.barangList.where((barang) {
                  final matchesSearch = barang.namaBarang.toLowerCase().contains(_searchQuery.toLowerCase());
                  final matchesCategory = _selectedKategoriFilter == null || barang.idKategori == _selectedKategoriFilter!.id;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (displayedList.isEmpty) {
                  return const Center(child: Text("Barang tidak ditemukan atau stok kosong."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0), // Padding disesuaikan
                  itemCount: displayedList.length,
                  itemBuilder: (context, index) {
                    final barang = displayedList[index];
                    final int selectedQuantity = _selectedItems[barang.id!] ?? 0;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    barang.namaBarang,
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF1D4A4B)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Stok tersedia: ${barang.stok}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Color(0xFF1D4A4B)),
                                    onPressed: () => _decrementQuantity(barang.id!),
                                  ),
                                  Text(
                                    '$selectedQuantity',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Color(0xFF1D4A4B)),
                                    onPressed: selectedQuantity < barang.stok
                                        ? () => _incrementQuantity(barang.id!)
                                        : null,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Tombol untuk melihat total
      floatingActionButton: _selectedItems.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: () {
          // TODO: Tampilkan dialog/halaman untuk konfirmasi dan simpan transaksi
          print('Item terpilih: $_selectedItems');
        },
        label: Text('Lihat Total (${_selectedItems.length} item)'),
        icon: Icon(Icons.shopping_cart_checkout),
        backgroundColor: const Color(0xFF6A8EEB),
      )
          : null,
    );
  }
}
