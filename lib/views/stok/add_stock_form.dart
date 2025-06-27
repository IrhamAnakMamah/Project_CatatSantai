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
  // --- PENAMBAHAN BARU ---
  final _modalPriceController = TextEditingController();
  // -----------------------

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryController>(context, listen: false).fetchKategori();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _unitPriceController.dispose();
    _modalPriceController.dispose(); // --- PENAMBAHAN BARU ---
    super.dispose();
  }

  void _showAddKategoriDialog() {
    // ... (Fungsi ini tidak berubah)
  }

  Future<void> _handleSubmit() async {
    // --- PENAMBAHAN BARU: Validasi untuk harga modal ---
    if (_itemNameController.text.isEmpty || _quantity == 0 || _unitPriceController.text.isEmpty || _modalPriceController.text.isEmpty || _selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi dan jumlah tidak boleh nol!')),
      );
      return;
    }

    // --- PENAMBAHAN BARU: Menyertakan hargaModal saat membuat objek Barang ---
    final barangBaru = Barang(
      namaBarang: _itemNameController.text,
      stok: _quantity,
      harga: double.tryParse(_unitPriceController.text) ?? 0.0,
      hargaModal: double.tryParse(_modalPriceController.text) ?? 0.0,
      idKategori: _selectedKategori!.id,
    );

    await Provider.of<StockController>(context, listen: false).addBarang(barangBaru);

    if (mounted) {
      showDialog(context: context, builder: (context) => const TransactionSuccessDialog());
      _itemNameController.clear();
      _unitPriceController.clear();
      _modalPriceController.clear(); // --- PENAMBAHAN BARU ---
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
            // Dropdown Jenis Barang (tidak berubah)
            // ...

            // Nama Barang (tidak berubah)
            // ...

            // Quantity Selector (tidak berubah)
            // ...

            // --- PENAMBAHAN BARU: Input untuk Harga Modal ---
            Text('Harga Modal / Beli (per item)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            TextField(
              controller: _modalPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan harga modal',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            // --------------------------------------------------

            // Harga Jual (label diubah agar lebih jelas)
            Text('Harga Jual (per item)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            TextField(
              controller: _unitPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan harga jual',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Simpan (tidak berubah)
            Align(
              alignment: Alignment.centerRight,
              child: Consumer<StockController>(
                builder: (context, controller, child) {
                  return controller.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _handleSubmit, child: null,
                    // ... sisa styling tombol
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
