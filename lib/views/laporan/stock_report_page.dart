import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/kategori_model.dart';

// Diubah menjadi StatefulWidget untuk mengelola state filter
class StockReportPage extends StatefulWidget {
  const StockReportPage({super.key});

  @override
  State<StockReportPage> createState() => _StockReportPageState();
}

class _StockReportPageState extends State<StockReportPage> {
  String _searchQuery = '';
  Kategori? _selectedKategoriFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryController>(context, listen: false).fetchKategori();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // == FITUR FILTER DAN PENCARIAN BARU ==
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari nama barang...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Consumer<CategoryController>(
              builder: (context, categoryController, child) {
                return DropdownButton<Kategori>(
                  value: _selectedKategoriFilter,
                  hint: Text('Kategori'),
                  icon: Icon(Icons.filter_list),
                  underline: SizedBox(),
                  items: [
                    DropdownMenuItem<Kategori>(value: null, child: Text('Semua')),
                    ...categoryController.kategoriList.map((kategori) => DropdownMenuItem<Kategori>(value: kategori, child: Text(kategori.namaKategori))).toList(),
                  ],
                  onChanged: (kategori) => setState(() => _selectedKategoriFilter = kategori),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Daftar Stok
        Expanded(
          child: Consumer<StockController>(
            builder: (context, controller, child) {
              if (controller.isLoading && controller.barangList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredList = controller.barangList.where((barang) {
                final matchesSearch = barang.namaBarang.toLowerCase().contains(_searchQuery.toLowerCase());
                final matchesCategory = _selectedKategoriFilter == null || barang.idKategori == _selectedKategoriFilter!.id;
                return matchesSearch && matchesCategory;
              }).toList();

              if (filteredList.isEmpty) {
                return const Center(child: Text('Barang tidak ditemukan.'));
              }

              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final barang = filteredList[index];
                  final bool isOutOfStock = barang.stok == 0;
                  return Opacity(
                    opacity: isOutOfStock ? 0.5 : 1.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(barang.namaBarang, style: TextStyle(fontSize: 16, color: const Color(0xFF1D4A4B))),
                              Text(
                                isOutOfStock ? 'Habis' : '${barang.stok} Unit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isOutOfStock ? Colors.red[700] : const Color(0xFF1D4A4B),
                                  fontWeight: isOutOfStock ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16, thickness: 0.5, color: Colors.grey),
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
    );
  }
}
