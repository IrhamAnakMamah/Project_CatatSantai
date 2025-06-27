import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../models/barang_model.dart';
import '../components/delete_confirmation_dialog.dart';
import '../components/delete_success_dialog.dart';

class DeleteStockForm extends StatefulWidget {
  const DeleteStockForm({super.key});

  @override
  State<DeleteStockForm> createState() => _DeleteStockFormState();
}

class _DeleteStockFormState extends State<DeleteStockForm> {
  // State untuk menyimpan barang yang dipilih dari dropdown
  Barang? _selectedBarang;

  void _handleDelete() {
    // Pastikan ada barang yang dipilih sebelum melanjutkan
    if (_selectedBarang == null) return;

    // Tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (dialogContext) => DeleteConfirmationDialog(
        onDeleteConfirmed: () async {
          // Panggil controller untuk menghapus barang
          await Provider.of<StockController>(context, listen: false)
              .deleteBarang(_selectedBarang!.id!);

          if (mounted) {
            // Tampilkan dialog sukses setelah data dihapus
            showDialog(
              context: context,
              builder: (context) => const DeleteSuccessDialog(),
            );
            // Reset pilihan dropdown
            setState(() {
              _selectedBarang = null;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer untuk mendapatkan daftar barang dari StockController
    return Consumer<StockController>(
      builder: (context, stockController, child) {
        // Tampilkan loading jika data sedang dimuat
        if (stockController.isLoading && stockController.barangList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama barang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D4A4B),
              ),
            ),
            const SizedBox(height: 8),
            // Dropdown untuk memilih barang yang akan dihapus
            DropdownButtonFormField<Barang>(
              value: _selectedBarang,
              hint: const Text('Pilih barang yang mau di hapus'),
              isExpanded: true, // Agar dropdown memenuhi lebar
              // Isi item dropdown dengan data dari controller
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Hapus
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                // Tombol hanya aktif jika ada barang yang dipilih
                onPressed: _selectedBarang == null ? null : _handleDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                ),
                child: Text(
                  'Hapus',
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
      },
    );
  }
}
