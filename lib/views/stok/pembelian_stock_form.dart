import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../models/barang_model.dart';
import '../components/transaction_success.dart';

class PembelianStockForm extends StatefulWidget {
  const PembelianStockForm({super.key});

  @override
  State<PembelianStockForm> createState() => _PembelianStockFormState();
}

class _PembelianStockFormState extends State<PembelianStockForm> {
  Barang? _selectedBarang;
  final _jumlahTambahController = TextEditingController();
  final _totalBiayaController = TextEditingController();

  @override
  void dispose() {
    _jumlahTambahController.dispose();
    _totalBiayaController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_selectedBarang == null || _jumlahTambahController.text.isEmpty || _totalBiayaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    final stockController = Provider.of<StockController>(context, listen: false);

    try {
      await stockController.restockBarang(
        context: context,
        idBarang: _selectedBarang!.id!,
        jumlahTambah: int.tryParse(_jumlahTambahController.text) ?? 0,
        totalBiaya: double.tryParse(_totalBiayaController.text) ?? 0.0,
      );

      if (mounted) {
        showDialog(context: context, builder: (context) => const TransactionSuccessDialog());
        // Reset form
        setState(() {
          _selectedBarang = null;
          _jumlahTambahController.clear();
          _totalBiayaController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StockController>(
      builder: (context, stockController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Barang untuk Ditambah Stoknya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            DropdownButtonFormField<Barang>(
              value: _selectedBarang,
              hint: const Text('Pilih barang yang sudah ada...'),
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
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),

            Text('Jumlah Stok yang Ditambah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            TextField(
              controller: _jumlahTambahController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan jumlah tambahan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Text('Total Harga Pembelian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            TextField(
              controller: _totalBiayaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan total biaya pembelian',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('Simpan Pembelian'),
              ),
            ),
          ],
        );
      },
    );
  }
}
