import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/barang_model.dart';
import '../../models/kategori_model.dart';
import '../components/transaction_success.dart';

class AddStockForm extends StatefulWidget {
  const AddStockForm({super.key});

  @override
  State<AddStockForm> createState() => _AddStockFormState();
}

class _AddStockFormState extends State<AddStockForm> {
  Kategori? _selectedKategori;
  final _itemNameController = TextEditingController();
  int _quantity = 0;
  final _unitPriceController = TextEditingController();
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _unitPriceController.addListener(_calculateTotal);
    Provider.of<CategoryController>(context, listen: false).fetchKategori();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _unitPriceController.removeListener(_calculateTotal);
    _unitPriceController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    double price = double.tryParse(_unitPriceController.text) ?? 0.0;
    setState(() {
      _totalPrice = _quantity * price;
    });
  }

  // == FUNGSI BARU UNTUK MENAMPILKAN DIALOG TAMBAH KATEGORI ==
  void _showAddKategoriDialog() {
    final kategoriNamaController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Jenis Barang Baru'),
          content: TextField(
            controller: kategoriNamaController,
            decoration: InputDecoration(hintText: "Nama Jenis Barang"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (kategoriNamaController.text.isNotEmpty) {
                  // Panggil controller untuk menambah kategori baru
                  Provider.of<CategoryController>(context, listen: false)
                      .addKategori(kategoriNamaController.text);
                  Navigator.pop(context);
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (_itemNameController.text.isEmpty || _quantity == 0 || _unitPriceController.text.isEmpty || _selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi dan jumlah tidak boleh nol!')),
      );
      return;
    }

    final barangBaru = Barang(
      namaBarang: _itemNameController.text,
      stok: _quantity,
      harga: double.tryParse(_unitPriceController.text) ?? 0.0,
      idKategori: _selectedKategori!.id,
    );

    await Provider.of<StockController>(context, listen: false).addBarang(barangBaru);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => const TransactionSuccessDialog(),
      );
      _itemNameController.clear();
      _unitPriceController.clear();
      setState(() {
        _quantity = 0;
        _selectedKategori = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jenis barang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            // == PERUBAHAN UI: Menambahkan Row dan Tombol '+' ==
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownButtonFormField<Kategori>(
                    value: _selectedKategori,
                    hint: const Text('Pilih jenis barang'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: categoryController.kategoriList.map((kategori) {
                      return DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori.namaKategori),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedKategori = newValue;
                      });
                    },
                  ),
                ),
                // Tombol untuk menambah kategori baru
                IconButton(
                  icon: Icon(Icons.add_circle, color: Theme.of(context).primaryColor, size: 30),
                  onPressed: _showAddKategoriDialog,
                  tooltip: 'Tambah Jenis Barang Baru',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sisa UI Anda tetap sama persis
            Text('Nama barang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama barang',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jumlah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
                Container(
                  decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Color(0xFF1D4A4B)),
                        onPressed: () {
                          setState(() {
                            if (_quantity > 0) _quantity--;
                            _calculateTotal();
                          });
                        },
                      ),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text('$_quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1D4A4B))),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Color(0xFF1D4A4B)),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                            _calculateTotal();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Harga satuan
            Text('Harga satuan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            TextField(
              controller: _unitPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan harga',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 30),

            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1D4A4B))),
                Text('Rp ${_totalPrice.toStringAsFixed(0)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1D4A4B))),
              ],
            ),
            const SizedBox(height: 40),

            // Tombol Simpan
            Align(
              alignment: Alignment.centerRight,
              child: Consumer<StockController>(
                builder: (context, controller, child) {
                  return controller.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6AC0BD),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                    ),
                    child: Text('Simpan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
