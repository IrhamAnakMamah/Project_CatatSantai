import 'package:catatsantai/views/notifikasi/notification_page.dart';
import 'package:catatsantai/views/pengaturan/profile_page.dart';
import 'package:catatsantai/views/pengaturan/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/barang_model.dart';
import '../../models/kategori_model.dart';
import 'transaction_confirmation_dialog.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final Map<int, int> _selectedItems = {};
  String _searchQuery = '';
  Kategori? _selectedKategoriFilter;

  @override
  void initState() {
    super.initState();
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

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
    });
  }

  void _showConfirmationDialog() {
    try {
      final stockController = Provider.of<StockController>(context, listen: false);
      final List<Barang> itemsInCart = [];
      double grandTotal = 0;

      for (var entry in _selectedItems.entries) {
        final int barangId = entry.key;
        final int jumlah = entry.value;
        final Barang barang = stockController.barangList.firstWhere((b) => b.id == barangId);

        itemsInCart.add(barang);
        grandTotal += barang.harga * jumlah;
      }

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return TransactionConfirmationDialog(
            selectedItems: _selectedItems,
            itemsInCart: itemsInCart,
            grandTotal: grandTotal,
          );
        },
      ).then((_) {
        _clearSelection();
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.settings, color: const Color(0xFF1D4A4B), size: 28),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications, color: const Color(0xFF1D4A4B), size: 28),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage())),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.person, color: const Color(0xFF1D4A4B), size: 28),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
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
                        hint: const Text('Kategori'),
                        icon: const Icon(Icons.filter_list),
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem<Kategori>(value: null, child: Text('Semua Kategori')),
                          ...categoryController.kategoriList.map((kategori) => DropdownMenuItem<Kategori>(value: kategori, child: Text(kategori.namaKategori))).toList(),
                        ],
                        onChanged: (kategori) => setState(() => _selectedKategoriFilter = kategori),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<StockController>(
                builder: (context, stockController, child) {
                  if (stockController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var filteredList = stockController.barangList.where((barang) {
                    final matchesSearch = barang.namaBarang.toLowerCase().contains(_searchQuery.toLowerCase());
                    final matchesCategory = _selectedKategoriFilter == null || barang.idKategori == _selectedKategoriFilter!.id;
                    return matchesSearch && matchesCategory;
                  }).toList();
                  filteredList.sort((a, b) {
                    if (a.stokSaatIni > 0 && b.stokSaatIni == 0) return -1;
                    if (a.stokSaatIni == 0 && b.stokSaatIni > 0) return 1;
                    return a.namaBarang.compareTo(b.namaBarang);
                  });
                  if (filteredList.isEmpty) {
                    return const Center(child: Text("Barang tidak ditemukan atau stok kosong."));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final barang = filteredList[index];
                      final int selectedQuantity = _selectedItems[barang.id!] ?? 0;

                      // === PERUBAHAN UTAMA DI SINI ===
                      // Logika untuk menonaktifkan tombol tambah jika jumlah pilihan = stok tersedia
                      final bool canIncrement = selectedQuantity < barang.stokSaatIni;

                      return Opacity(
                        opacity: barang.stokSaatIni == 0 ? 0.6 : 1.0,
                        child: Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(barang.namaBarang, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1D4A4B))),
                                      const SizedBox(height: 4),
                                      Text('Stok tersedia: ${barang.stokSaatIni}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                    ])),
                                    Container(
                                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          IconButton(icon: const Icon(Icons.remove, color: Color(0xFF1D4A4B)), onPressed: () => _decrementQuantity(barang.id!)),
                                          Text('$selectedQuantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          // Tombol tambah akan nonaktif jika canIncrement bernilai false
                                          IconButton(
                                              icon: Icon(Icons.add, color: canIncrement ? const Color(0xFF1D4A4B) : Colors.grey),
                                              onPressed: canIncrement ? () => _incrementQuantity(barang.id!) : null
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (barang.stokSaatIni == 0)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Habis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                ),
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
      ),
      floatingActionButton: _selectedItems.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: _showConfirmationDialog,
        label: Text('Lihat Total (${_selectedItems.length} item)'),
        icon: const Icon(Icons.shopping_cart_checkout),
        backgroundColor: const Color(0xFF6A8EEB),
      )
          : null,
    );
  }
}