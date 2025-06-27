import 'package:flutter/material.dart';
// Impor form yang sudah diubah namanya
import 'add_new_item_form.dart'; // Sekarang ini adalah 'Tambah Barang'
import 'restock_form.dart';      // Sekarang ini adalah 'Restock Barang'
import 'edit_stock_form.dart';
import 'delete_stock_form.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  // State untuk segmented control sekarang memiliki 4 pilihan
  // 0: Restock Barang, 1: Tambah Barang, 2: Edit, 3: Hapus
  List<bool> _isSelected = [true, false, false, false]; // Default: Restock Barang aktif

  @override
  Widget build(BuildContext context) {
    int activeTabIndex = _isSelected.indexOf(true);

    // Helper widget untuk menampilkan form yang sesuai dengan tab aktif
    Widget buildCurrentForm() {
      switch (activeTabIndex) {
        case 0:
          return const RestockForm(); // Menampilkan form restock untuk menambah stok barang yang sudah ada
        case 1:
          return const AddNewItemForm(); // Menampilkan form tambah barang baru
        case 2:
          return const EditStockForm();
        case 3:
          return const DeleteStockForm();
        default:
          return const RestockForm(); // Default kembali ke RestockForm
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            // Anda bisa tambahkan header yang konsisten dengan desain aplikasi Anda di sini
            // Contohnya seperti pada halaman Transaksi atau Laporan
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       IconButton(
            //         icon: Icon(Icons.settings, color: const Color(0xFF1D4A4B), size: 28),
            //         onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
            //       ),
            //       Row(children: [
            //         IconButton(
            //           icon: Icon(Icons.notifications, color: const Color(0xFF1D4A4B), size: 28),
            //           onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage())),
            //         ),
            //         const SizedBox(width: 8),
            //         IconButton(
            //           icon: Icon(Icons.person, color: const Color(0xFF1D4A4B), size: 28),
            //           onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
            //         ),
            //       ]),
            //     ],
            //   ),
            // ),

            // Segmented Control (dengan 4 pilihan baru)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
                ],
              ),
              child: ToggleButtons(
                isSelected: _isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _isSelected.length; i++) {
                      _isSelected[i] = (i == index);
                    }
                  });
                },
                fillColor: const Color(0xFF6AC0BD), // Warna tosca/biru yang konsisten
                selectedColor: Colors.white,
                color: const Color(0xFF1D4A4B), // Warna teks tidak aktif
                borderRadius: BorderRadius.circular(10),
                borderWidth: 0,
                constraints: BoxConstraints.expand(width: (MediaQuery.of(context).size.width - 52) / 4, height: 45), // Dibagi 4
                children: const <Widget>[
                  Text('Restock Barang', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Tambah Barang', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form aktif akan ditampilkan di sini
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: buildCurrentForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}