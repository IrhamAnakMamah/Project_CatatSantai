import 'package:flutter/material.dart';
import 'package:catatsantai/assets/delete_confirmation_dialog.dart'; // Import dialog konfirmasi hapus
import 'package:catatsantai/assets/delete_success_dialog.dart'; // Import dialog sukses hapus

class DeleteStockForm extends StatefulWidget {
  const DeleteStockForm({super.key});

  @override
  State<DeleteStockForm> createState() => _DeleteStockFormState();
}

class _DeleteStockFormState extends State<DeleteStockForm> {
  String? _selectedItemToDelete; // Untuk dropdown pilih barang yang mau dihapus

  // List contoh untuk dropdown Nama barang (barang yang sudah ada)
  final List<String> _existingItems = ['Nasi Goreng (Makanan)', 'Es Teh (Minuman)', 'T-Shirt (Pakaian)'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nama barang (Dropdown untuk pilih barang yang mau dihapus)
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
          value: _selectedItemToDelete,
          hint: const Text('Pilih barang yang mau di hapus'),
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
              _selectedItemToDelete = newValue;
            });
          },
        ),
        const SizedBox(height: 40),

        // Tombol Hapus
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              // Tampilkan dialog konfirmasi hapus
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteConfirmationDialog(
                    onDeleteConfirmed: () {
                      // Logika yang akan dijalankan jika user menekan 'Hapus' di dialog konfirmasi
                      print('Data $_selectedItemToDelete berhasil dihapus!');
                      // Tampilkan dialog sukses setelah hapus
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const DeleteSuccessDialog(); // Panggil dialog sukses hapus di sini
                        },
                      );
                    },
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600], // Warna merah untuk tombol hapus
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5, // Bayangan tombol
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
  }
}
