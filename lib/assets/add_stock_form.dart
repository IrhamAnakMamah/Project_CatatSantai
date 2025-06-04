import 'package:flutter/material.dart';
import 'package:catatsantai/assets/transaction_success.dart'; // Import dialog sukses transaksi

class AddStockForm extends StatefulWidget {
  const AddStockForm({super.key});

  @override
  State<AddStockForm> createState() => _AddStockFormState();
}

class _AddStockFormState extends State<AddStockForm> {
  String? _selectedItemType; // Untuk dropdown Jenis barang
  TextEditingController _itemNameController = TextEditingController(); // Untuk Nama barang
  int _quantity = 0; // Untuk Jumlah
  TextEditingController _unitPriceController = TextEditingController(); // Untuk Harga satuan
  double _totalPrice = 0.0; // Total harga

  final List<String> _itemTypes = ['Makanan', 'Minuman', 'Pakaian', 'Elektronik'];

  @override
  void dispose() {
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
        // Jenis barang Dropdown
        Text(
          'Jenis barang',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D4A4B),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedItemType,
          hint: const Text('Masukkan jenis barang'),
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
          items: _itemTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedItemType = newValue;
            });
          },
        ),
        const SizedBox(height: 20),

        // Nama barang Text Field
        Text(
          'Nama barang',
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

        // Harga satuan Text Field
        Text(
          'Harga satuan',
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

        // Save Button (untuk Tambah)
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Tambahkan logika untuk menyimpan stok baru
              print('Simpan Tambah Stok:');
              print('Jenis Barang: $_selectedItemType');
              print('Nama Barang: ${_itemNameController.text}');
              print('Jumlah: $_quantity');
              print('Harga Satuan: ${_unitPriceController.text}');
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
