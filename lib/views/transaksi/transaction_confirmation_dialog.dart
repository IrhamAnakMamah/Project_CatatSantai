import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/barang_model.dart';

class TransactionConfirmationDialog extends StatelessWidget {
  // Dialog ini akan menerima "keranjang belanja" dari halaman sebelumnya
  final Map<int, int> selectedItems;
  final List<Barang> itemsInCart;
  final double grandTotal;

  const TransactionConfirmationDialog({
    super.key,
    required this.selectedItems,
    required this.itemsInCart,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Konfirmasi Transaksi'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daftar barang yang dipilih untuk dikonfirmasi
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: itemsInCart.length,
                itemBuilder: (context, index) {
                  final barang = itemsInCart[index];
                  final jumlah = selectedItems[barang.id!]!;
                  final subtotal = barang.harga * jumlah;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(barang.namaBarang),
                    subtitle: Text('Rp ${barang.harga} x $jumlah'),
                    trailing: Text('Rp $subtotal'),
                  );
                },
              ),
            ),
            const Divider(thickness: 1.5),
            // Tampilan Total Harga
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Harga:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Rp $grandTotal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.of(context).pop(), // Cukup tutup dialog
        ),
        // Tombol untuk menyimpan transaksi
        Consumer<TransactionController>(
          builder: (context, transactionController, child) {
            return transactionController.isLoading
                ? const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())
                : ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A8EEB)),
              child: const Text('Simpan Transaksi', style: TextStyle(color: Colors.white)),
              onPressed: () {
                // Panggil fungsi submit dari controller saat tombol ditekan
                transactionController
                    .submitTransaction(context: context, selectedItems: selectedItems)
                    .then((_) {
                  // Jika berhasil, tutup dialog
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaksi berhasil disimpan!')),
                  );
                }).catchError((error) {
                  // Jika gagal, tampilkan pesan error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${error.toString().replaceAll('Exception: ', '')}')),
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }
}
