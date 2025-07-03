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
  final _stokAwalController = TextEditingController(); // BARU: Untuk menampilkan Stok Awal (read-only)
  final _stokSaatIniController = TextEditingController(); // UBAH: Mengganti _jumlahController
  final _hargaJualController = TextEditingController();
  final _hargaModalController = TextEditingController();

  // State untuk menyimpan barang yang sedang dipilih dari dropdown
  Barang? _selectedBarang;

  @override
  void dispose() {
    _namaController.dispose();
    _stokAwalController.dispose();    // BARU: Dispose controller stok awal
    _stokSaatIniController.dispose(); // UBAH: Dispose controller stok saat ini
    _hargaJualController.dispose();
    _hargaModalController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani penyimpanan perubahan
  Future<void> _handleSubmit() async {
    // Jangan lakukan apa-apa jika tidak ada barang yang dipilih
    if (_selectedBarang == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih barang yang ingin diedit terlebih dahulu!')),
      );
      return;
    }

    // Validasi input
    if (_namaController.text.isEmpty ||
        _stokSaatIniController.text.isEmpty ||
        _hargaJualController.text.isEmpty ||
        _hargaModalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    // Buat objek Barang yang sudah diperbarui dari input form
    final barangUpdate = Barang(
      id: _selectedBarang!.id,
      namaBarang: _namaController.text,
      stokAwal: _selectedBarang!.stokAwal, // TIDAK BERUBAH: Menggunakan stokAwal dari barang terpilih
      stokSaatIni: int.tryParse(_stokSaatIniController.text) ?? 0, // UBAH: Menggunakan stokSaatIni
      harga: double.tryParse(_hargaJualController.text) ?? 0.0,
      hargaModal: double.tryParse(_hargaModalController.text) ?? 0.0,
      idKategori: _selectedBarang!.idKategori,
    );

    // Panggil fungsi update dari StockController
    await Provider.of<StockController>(context, listen: false).updateBarang(context, barangUpdate);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => const TransactionSuccessDialog(),
      );
      // Reset form setelah berhasil
      setState(() {
        _selectedBarang = null;
        _namaController.clear();
        _stokAwalController.clear();     // BARU: Clear controller stok awal
        _stokSaatIniController.clear();  // UBAH: Clear controller stok saat ini
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
                    _stokAwalController.text = barang.stokAwal.toString();     // BARU: Isi stok awal (read-only)
                    _stokSaatIniController.text = barang.stokSaatIni.toString(); // UBAH: Isi stok saat ini
                    _hargaJualController.text = barang.harga.toString();
                    _hargaModalController.text = barang.hargaModal.toString();
                  }
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

            // Field-field lainnya akan non-aktif sampai ada barang yang dipilih
            _buildTextField(
              controller: _namaController,
              label: 'Nama Barang',
              enabled: _selectedBarang != null,
            ),
            _buildTextField(
              controller: _stokAwalController, // BARU: Field untuk Stok Awal (read-only)
              label: 'Stok Awal',
              keyboardType: TextInputType.number,
              enabled: false, // Selalu non-aktif untuk editing
            ),
            _buildTextField(
              controller: _stokSaatIniController, // UBAH: Field untuk Stok Saat Ini
              label: 'Stok Saat Ini',
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
              child: Consumer<StockController>(
                builder: (context, controller, child) {
                  return controller.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    // Tombol hanya aktif jika ada barang yang dipilih
                    onPressed: _selectedBarang == null ? null : _handleSubmit,
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
                      'Simpan Perubahan',
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
            readOnly: !enabled, // Menjadikan field read-only jika tidak enabled
            keyboardType: keyboardType,
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
              filled: !enabled, // Mengisi warna latar belakang jika non-aktif
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}