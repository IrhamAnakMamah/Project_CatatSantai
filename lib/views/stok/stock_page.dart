import 'package:flutter/material.dart';
import 'package:catatsantai/views/notifikasi/notification_page.dart';
import 'package:catatsantai/views/pengaturan/profile_page.dart';
import 'package:catatsantai/views/pengaturan/settings_page.dart';
import 'add_new_item_form.dart';
import 'restock_form.dart';
import 'edit_stock_form.dart';
import 'delete_stock_form.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  // 0: Restock Barang, 1: Tambah Barang, 2: Edit, 3: Hapus
  List<bool> _isSelected = [true, false, false, false];
  final List<String> _labels = ['Restock Barang', 'Tambah Barang', 'Edit', 'Hapus'];

  @override
  Widget build(BuildContext context) {
    int activeTabIndex = _isSelected.indexOf(true);

    Widget buildCurrentForm() {
      switch (activeTabIndex) {
        case 0:
          return const RestockForm();
        case 1:
          return const AddNewItemForm();
        case 2:
          return const EditStockForm();
        case 3:
          return const DeleteStockForm();
        default:
          return const RestockForm();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: SafeArea(
        child: Column(
          children: [
            // Header (tetap sama)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.settings, color: const Color(0xFF1D4A4B), size: 28),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications, color: const Color(0xFF1D4A4B), size: 28),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage())),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.person, color: const Color(0xFF1D4A4B), size: 28),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // == SEGMENTED CONTROL BARU DENGAN FONT LEBIH KECIL DAN RATA TENGAH ==
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: List.generate(_labels.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          for (int i = 0; i < _isSelected.length; i++) {
                            _isSelected[i] = (i == index);
                          }
                        });
                      },
                      child: Container(
                        height: 45,
                        alignment: Alignment.center, // <-- BARU: Mengatur rata tengah
                        decoration: BoxDecoration(
                          color: _isSelected[index] ? const Color(0xFF6AC0BD) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _labels[index],
                          textAlign: TextAlign.center, // <-- BARU: Mengatur rata tengah untuk teks
                          style: TextStyle(
                            color: _isSelected[index] ? Colors.white : const Color(0xFF1D4A4B),
                            fontWeight: FontWeight.bold,
                            fontSize: 13, // <-- UBAH: Mengurangi ukuran font
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            // == AKHIR SEGMENTED CONTROL BARU ==

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