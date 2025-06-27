import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../models/barang_model.dart';
import '../components/transaction_success.dart';

class RestockForm extends StatefulWidget {
  const RestockForm({super.key});

  @override
  State<RestockForm> createState() => _RestockFormState();
}

class _RestockFormState extends State<RestockForm> {
  Barang? _selectedBarang;
  final _jumlahTambahController = TextEditingController();
  // final _totalBiayaController = TextEditingController(); // Hapus controller ini

  @override
  void dispose() {
    _jumlahTambahController.dispose();
    // _totalBiayaController.dispose(); // Hapus dispose untuk controller ini
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_selectedBarang == null || _jumlahTambahController.text.isEmpty) { // Hapus validasi totalBiayaController
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih barang dan masukkan jumlah stok yang ditambah!')),
      );
      return;
    }

    final int jumlahTambah = int.tryParse(_jumlahTambahController.text) ?? 0;
    if (jumlahTambah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah stok yang ditambah harus lebih dari nol!')),
      );
      return;
    }

    // Hitung totalBiaya secara otomatis
    // Gunakan hargaModal dari barang yang dipilih
    final double hargaModalPerUnit = _selectedBarang!.hargaModal;
    final double totalBiaya = hargaModalPerUnit * jumlahTambah;

    final stockController = Provider.of<StockController>(context, listen: false);

    try {
      await stockController.restockBarang(
        context: context,
        idBarang: _selectedBarang!.id!,
        jumlahTambah: jumlahTambah,
        totalBiaya: totalBiaya, // Gunakan totalBiaya yang sudah dihitung
      );

      if (mounted) {
        showDialog(context: context, builder: (context) => const TransactionSuccessDialog());
        // Reset form
        setState(() {
          _selectedBarang = null;
          _jumlahTambahController.clear();
          // _totalBiayaController.clear(); // Hapus clear untuk controller ini
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}')),
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
            const SizedBox(height: 20),

            Text('Jumlah Stok yang Ditambah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            TextField(
              controller: _jumlahTambahController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan jumlah tambahan',
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

            // Bagian "Total Harga Pembelian" dihapus dari sini

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