import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';
import '../../models/barang_model.dart';
import '../components/transaction_success.dart';

class EditStockForm extends StatefulWidget {
  const EditStockForm({super.key});

  @override
  State<EditStockForm> createState() => _EditStockFormState();
}

class _EditStockFormState extends State<EditStockForm> {
  // Controller untuk setiap field di form
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _hargaJualController = TextEditingController();
  final _hargaModalController = TextEditingController();

  // State untuk menyimpan barang yang sedang dipilih dari dropdown
  Barang? _selectedBarang;

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    _hargaJualController.dispose();
    _hargaModalController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani penyimpanan perubahan
  Future<void> _handleSubmit() async {
    // Jangan lakukan apa-apa jika tidak ada barang yang dipilih
    if (_selectedBarang == null) return;

    // Buat objek Barang yang sudah diperbarui dari input form
    final barangUpdate = Barang(
      id: _selectedBarang!.id,
      namaBarang: _namaController.text,
      stok: int.tryParse(_jumlahController.text) ?? 0,
      harga: double.tryParse(_hargaJualController.text) ?? 0.0,
      hargaModal: double.tryParse(_hargaModalController.text) ?? 0.0,
      idKategori: _selectedBarang!.idKategori,
    );

    // Panggil fungsi update dari StockController
    await Provider.of<StockController>(context, listen: false).updateBarang(barangUpdate);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => const TransactionSuccessDialog(),
      );
      // Reset form setelah berhasil
      setState(() {
        _selectedBarang = null;
        _namaController.clear();
        _jumlahController.clear();
        _hargaJualController.clear();
        _hargaModalController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer untuk mendapatkan daftar barang dari StockController
    return Consumer<StockController>(
      builder: (context, stockController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Barang untuk Diedit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
            const SizedBox(height: 8),
            // Dropdown untuk memilih barang
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
                // Saat barang dipilih, update state dan isi semua field form
                setState(() {
                  _selectedBarang = barang;
                  if (barang != null) {
                    _namaController.text = barang.namaBarang;
                    _jumlahController.text = barang.stok.toString();
                    _hargaJualController.text = barang.harga.toString();
                    _hargaModalController.text = barang.hargaModal.toString();
                  }
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),

            // Field-field lainnya akan non-aktif sampai ada barang yang dipilih
            _buildTextField(
              controller: _namaController,
              label: 'Nama Barang',
              enabled: _selectedBarang != null,
            ),
            _buildTextField(
              controller: _jumlahController,
              label: 'Jumlah Stok',
              keyboardType: TextInputType.number,
              enabled: _selectedBarang != null,
            ),
            _buildTextField(
              controller: _hargaModalController,
              label: 'Harga Modal / Beli',
              keyboardType: TextInputType.number,
              enabled: _selectedBarang != null,
            ),
            _buildTextField(
              controller: _hargaJualController,
              label: 'Harga Jual',
              keyboardType: TextInputType.number,
              enabled: _selectedBarang != null,
            ),
            const SizedBox(height: 40),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                // Tombol hanya aktif jika ada barang yang dipilih
                onPressed: _selectedBarang == null ? null : _handleSubmit,
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper widget untuk membuat TextField agar tidak duplikasi kode
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: enabled ? const Color(0xFF1D4A4B) : Colors.grey)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: !enabled,
              fillColor: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
