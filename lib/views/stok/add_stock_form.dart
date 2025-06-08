import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../models/barang_model.dart';
import '../components/transaction_success.dart'; // Pastikan path ini benar

// Mengubah menjadi StatefulWidget untuk mengelola controller form
class AddStockForm extends StatefulWidget {
  const AddStockForm({super.key});

  @override
  State<AddStockForm> createState() => _AddStockFormState();
}

class _AddStockFormState extends State<AddStockForm> {
  // Controller untuk setiap input field
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _hargaController = TextEditingController();
  String? _selectedItemType; // State untuk dropdown
  final List<String> _itemTypes = ['Makanan', 'Minuman', 'Pakaian', 'Elektronik'];

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani logika saat tombol "Simpan" ditekan
  Future<void> _handleSubmit() async {
    if (_namaController.text.isEmpty || _jumlahController.text.isEmpty || _hargaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    final barangBaru = Barang(
      namaBarang: _namaController.text,
      stok: int.tryParse(_jumlahController.text) ?? 0,
      harga: double.tryParse(_hargaController.text) ?? 0.0,
      // idKategori bisa di-handle di sini jika perlu
    );

    // Memanggil fungsi dari StockController untuk menambah barang
    await Provider.of<StockController>(context, listen: false).addBarang(barangBaru);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => const TransactionSuccessDialog(),
      );
      // Kosongkan form setelah berhasil
      _namaController.clear();
      _jumlahController.clear();
      _hargaController.clear();
      setState(() {
        _selectedItemType = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI di bawah ini adalah UI asli Anda, hanya dengan penambahan
    // 'controller' pada TextField dan 'onPressed' pada ElevatedButton.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Jenis barang Dropdown
        Text('Jenis barang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedItemType,
          hint: const Text('Masukkan jenis barang'),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: _itemTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedItemType = newValue;
            });
          },
        ),
        const SizedBox(height: 20),

        // Nama barang Text Field
        Text('Nama barang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
        const SizedBox(height: 8),
        TextField(
          controller: _namaController, // Dihubungkan ke controller
          decoration: InputDecoration(
            hintText: 'Masukkan nama barang',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 20),

        // Quantity Selector - Bagian ini belum bisa dinamis, kita hubungkan TextField saja
        Text('Jumlah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
        const SizedBox(height: 8),
        TextField(
            controller: _jumlahController, // Dihubungkan ke controller
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Masukkan jumlah',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            )
        ),
        const SizedBox(height: 20),

        // Harga satuan Text Field
        Text('Harga satuan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
        const SizedBox(height: 8),
        TextField(
          controller: _hargaController, // Dihubungkan ke controller
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Masukkan harga',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 30),

        // Tombol Simpan
        Align(
          alignment: Alignment.centerRight,
          child: Consumer<StockController>( // Dibungkus Consumer untuk status loading
            builder: (context, controller, child) {
              return controller.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _handleSubmit, // Dihubungkan ke fungsi handle
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
  }
}
