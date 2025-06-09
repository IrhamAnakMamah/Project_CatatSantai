import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../models/barang_model.dart';
import '../components/transaction_success.dart';

class EditStockForm extends StatefulWidget {
  // Tidak lagi menerima 'barang' di constructor
  const EditStockForm({super.key});

  @override
  State<EditStockForm> createState() => _EditStockFormState();
}

class _EditStockFormState extends State<EditStockForm> {
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _hargaController = TextEditingController();
  Barang? _selectedBarang; // State untuk menyimpan barang yang dipilih

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_selectedBarang == null) return; // Jangan lakukan apa-apa jika belum ada barang dipilih

    final barangUpdate = Barang(
      id: _selectedBarang!.id,
      namaBarang: _namaController.text,
      stok: int.tryParse(_jumlahController.text) ?? 0,
      harga: double.tryParse(_hargaController.text) ?? 0.0,
      idKategori: _selectedBarang!.idKategori,
    );
    await Provider.of<StockController>(context, listen: false).updateBarang(barangUpdate);
    if (mounted) {
      showDialog(context: context, builder: (context) => const TransactionSuccessDialog());
      // Kosongkan form setelah berhasil
      setState(() {
        _selectedBarang = null;
        _namaController.clear();
        _jumlahController.clear();
        _hargaController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StockController>(
      builder: (context, stockController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Barang untuk Diedit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            DropdownButtonFormField<Barang>(
              value: _selectedBarang,
              hint: const Text('Pilih barang...'),
              isExpanded: true,
              items: stockController.barangList.map((barang) {
                return DropdownMenuItem<Barang>(
                  value: barang,
                  child: Text(barang.namaBarang),
                );
              }).toList(),
              onChanged: (barang) {
                setState(() {
                  _selectedBarang = barang;
                  if (barang != null) {
                    _namaController.text = barang.namaBarang;
                    _jumlahController.text = barang.stok.toString();
                    _hargaController.text = barang.harga.toString();
                  }
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),

            // Field lainnya akan non-aktif sampai barang dipilih
            Text('Nama barang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            TextField(controller: _namaController, enabled: _selectedBarang != null, decoration: InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 20),

            Text('Jumlah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            TextField(controller: _jumlahController, enabled: _selectedBarang != null, keyboardType: TextInputType.number, decoration: InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 20),

            Text('Harga satuan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            TextField(controller: _hargaController, enabled: _selectedBarang != null, keyboardType: TextInputType.number, decoration: InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 40),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                // Tombol hanya aktif jika barang sudah dipilih
                onPressed: _selectedBarang == null ? null : _handleSubmit,
                child: Text('Simpan Perubahan'),
              ),
            ),
          ],
        );
      },
    );
  }
}
