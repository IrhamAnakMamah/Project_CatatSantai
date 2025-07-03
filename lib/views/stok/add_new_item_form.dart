import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/barang_model.dart';
import '../../models/kategori_model.dart';
import '../components/transaction_success.dart';

class AddNewItemForm extends StatefulWidget {
  const AddNewItemForm({super.key});

  @override
  State<AddNewItemForm> createState() => _AddNewItemFormState();
}

class _AddNewItemFormState extends State<AddNewItemForm> {
  Kategori? _selectedKategori;
  final _itemNameController = TextEditingController();
  int _initialStock = 0;
  final _unitPriceController = TextEditingController();
  final _modalPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryController>(context, listen: false).fetchKategori();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _unitPriceController.dispose();
    _modalPriceController.dispose();
    super.dispose();
  }

  void _showAddKategoriDialog() {
    final newCategoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Tambah Kategori Baru'),
          content: TextField(
            controller: newCategoryController,
            decoration: const InputDecoration(hintText: 'Nama Kategori'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: const Text('Tambah'),
              onPressed: () async {
                if (newCategoryController.text.isNotEmpty) {
                  await Provider.of<CategoryController>(context, listen: false)
                      .addKategori(newCategoryController.text);
                  if (mounted) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kategori ${newCategoryController.text} berhasil ditambahkan!')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _handleSubmit() async {
    if (_itemNameController.text.isEmpty || _initialStock <= 0 || _unitPriceController.text.isEmpty || _modalPriceController.text.isEmpty || _selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi dan stok awal harus lebih dari nol!')),
      );
      return;
    }

    final barangBaru = Barang(
      namaBarang: _itemNameController.text,
      stokAwal: _initialStock,
      stokSaatIni: _initialStock,
      harga: double.tryParse(_unitPriceController.text) ?? 0.0,
      hargaModal: double.tryParse(_modalPriceController.text) ?? 0.0,
      idKategori: _selectedKategori!.id,
    );

    // <-- UBAH DI SINI: Meneruskan context
    await Provider.of<StockController>(context, listen: false).addBarang(context, barangBaru);

    if (mounted) {
      showDialog(context: context, builder: (context) => const TransactionSuccessDialog());
      _itemNameController.clear();
      _unitPriceController.clear();
      _modalPriceController.clear();
      setState(() {
        _initialStock = 0;
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
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Kategori>(
                    value: _selectedKategori,
                    hint: const Text('Pilih jenis barang'),
                    isExpanded: true,
                    items: categoryController.kategoriList.map((kategori) {
                      return DropdownMenuItem<Kategori>(
                        value: kategori,
                        child: Text(kategori.namaKategori),
                      );
                    }).toList(),
                    onChanged: (kategori) {
                      setState(() {
                        _selectedKategori = kategori;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FC0BD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: _showAddKategoriDialog,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text('Nama barang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama barang',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            Text('Stok Awal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Color(0xFF1D4A4B)),
                    onPressed: () {
                      setState(() {
                        if (_initialStock > 0) {
                          _initialStock--;
                        }
                      });
                    },
                  ),
                  Text(
                    '$_initialStock',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D4A4B),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Color(0xFF1D4A4B)),
                    onPressed: () {
                      setState(() {
                        _initialStock++;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('Harga Modal / Beli (per item)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            TextField(
              controller: _modalPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan harga modal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            Text('Harga Jual (per item)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            TextField(
              controller: _unitPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan harga jual',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 40),

            Align(
              alignment: Alignment.centerRight,
              child: Consumer<StockController>(
                builder: (context, controller, child) {
                  return controller.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A8EEB), // Warna biru
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      minimumSize: const Size.fromHeight(50), // Lebar penuh
                    ),
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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