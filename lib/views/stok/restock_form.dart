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
  int _quantityToRestock = 0; // Menggunakan int untuk jumlah stok
  // Hapus: final _totalBiayaController = TextEditingController();

  @override
  void dispose() {
    // Hapus: _totalBiayaController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_selectedBarang == null || _quantityToRestock <= 0) { // Hapus validasi totalBiayaController
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih barang dan masukkan jumlah stok yang ditambah!')),
      );
      return;
    }

    final int jumlahTambah = _quantityToRestock;
    // Hitung totalBiaya secara otomatis
    // Gunakan hargaModal dari barang yang dipilih
    final double hargaModalPerUnit = _selectedBarang!.hargaModal;
    final double totalBiaya = hargaModalPerUnit * jumlahTambah; // Hitung otomatis

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
        setState(() {
          _selectedBarang = null;
          _quantityToRestock = 0; // Reset jumlah
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
            Text('Pilih Barang untuk Restock', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
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
                  // Reset jumlah restock saat barang berubah
                  _quantityToRestock = 0;
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

            // Kontrol Plus/Minus untuk Jumlah Stok
            Text('Jumlah Stok yang Ditambah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
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
                    onPressed: _selectedBarang == null ? null : () {
                      setState(() {
                        if (_quantityToRestock > 0) {
                          _quantityToRestock--;
                        }
                      });
                    },
                  ),
                  Text(
                    '$_quantityToRestock',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D4A4B),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Color(0xFF1D4A4B)),
                    onPressed: _selectedBarang == null ? null : () {
                      setState(() {
                        _quantityToRestock++;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Hapus: Input untuk Total Biaya Restock

            Align(
              alignment: Alignment.centerRight,
              child: Consumer<StockController>(
                builder: (context, controller, child) {
                  return controller.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: (_selectedBarang == null || _quantityToRestock <= 0) ? null : _handleSubmit, // Hapus validasi totalBiayaController.text.isEmpty
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A8EEB),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(
                      'Simpan', // Mengubah teks tombol menjadi 'Simpan'
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