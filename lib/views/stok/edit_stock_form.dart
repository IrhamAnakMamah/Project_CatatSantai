import 'package:flutter/material.dart';
import 'package:catatsantai/views/components/transaction_success.dart'; // Import dialog sukses transaksi

class EditStockForm extends StatefulWidget {
  const EditStockForm({super.key});

  @override
  State<EditStockForm> createState() => _EditStockFormState();
}

class _EditStockFormState extends State<EditStockForm> {
  String? _selectedExistingItem; // Untuk dropdown Nama barang (yang mau diedit)
  TextEditingController _itemTypeController = TextEditingController(); // Untuk Edit jenis barang
  TextEditingController _itemNameController = TextEditingController(); // Untuk Edit Nama barang
  int _quantity = 0; // Untuk Jumlah
  TextEditingController _unitPriceController = TextEditingController(); // Untuk Edit Harga satuan
  double _totalPrice = 0.0; // Total harga

  final List<String> _existingItems = ['Nasi Goreng (Makanan)', 'Es Teh (Minuman)', 'T-Shirt (Pakaian)'];

  @override
  void dispose() {
    _itemTypeController.dispose();
    _itemNameController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    double price = double.tryParse(_unitPriceController.text) ?? 0.0;
    setState(() {
      _totalPrice = _quantity * price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nama barang (Dropdown untuk pilih barang yang mau diedit)
        Text(
          'Nama barang',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D4A4B),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedExistingItem,
          hint: const Text('Pilih barang yang mau di edit'),
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
          items: _existingItems.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedExistingItem = newValue;
              // TODO: Load data barang yang dipilih ke text field di bawah
              // Contoh:
              // _itemTypeController.text = 'Makanan';
              // _itemNameController.text = 'Nasi Goreng';
              // _quantity = 1;
              // _unitPriceController.text = '15000';
              // _calculateTotal();
            });
          },
        ),
        const SizedBox(height: 20),

        // Edit jenis barang Text Field
        Text(
          'Edit jenis barang',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D4A4B),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _itemTypeController,
          decoration: InputDecoration(
            hintText: 'Masukkan jenis barang',
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

        // Edit Nama barang Text Field
        Text(
          'Edit Nama barang',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D4A4B),
          ),
        ),
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

        // Quantity Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jumlah',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D4A4B),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9), // Warna abu-abu muda
                borderRadius: BorderRadius.circular(10),
              ),
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
                    child: Text(
                      '$_quantity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D4A4B),
                      ),
                    ),
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

        // Edit Harga satuan Text Field
        Text(
          'Edit Harga satuan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D4A4B),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _unitPriceController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _calculateTotal();
          },
          decoration: InputDecoration(
            hintText: 'Masukkan harga',
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
        const SizedBox(height: 30),

        // Total Price Display
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D4A4B),
              ),
            ),
            Text(
              'Rp ${_totalPrice.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D4A4B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),

        // Save Button (untuk Edit)
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Tambahkan logika untuk menyimpan perubahan stok
              print('Simpan Edit Stok:');
              print('Barang yang diedit: $_selectedExistingItem');
              print('Edit Jenis Barang: ${_itemTypeController.text}');
              print('Edit Nama Barang: ${_itemNameController.text}');
              print('Jumlah: $_quantity');
              print('Edit Harga Satuan: ${_unitPriceController.text}');
              print('Total: $_totalPrice');

              // Tampilkan dialog sukses setelah simpan
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const TransactionSuccessDialog(); // Sekarang sudah aktif!
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6AC0BD),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
            ),
            child: Text(
              'Simpan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
