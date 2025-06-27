import 'package:flutter/material.dart';
import 'add_stock_form.dart';
import 'edit_stock_form.dart';
import 'delete_stock_form.dart';
import 'pembelian_stock_form.dart'; // Impor form baru yang akan kita buat

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  // State untuk segmented control sekarang memiliki 4 pilihan
  // 0: Tambah, 1: Pembelian, 2: Edit, 3: Hapus
  List<bool> _isSelected = [true, false, false, false]; // Default: Tambah aktif

  @override
  Widget build(BuildContext context) {
    int activeTabIndex = _isSelected.indexOf(true);

    // Helper widget untuk menampilkan form yang sesuai dengan tab aktif
    Widget buildCurrentForm() {
      switch (activeTabIndex) {
        case 0:
          return const AddStockForm();
        case 1:
          return const PembelianStockForm(); // Tampilkan form baru
        case 2:
          return const EditStockForm(); // Form ini sekarang harusnya sudah direvisi
        case 3:
          return const DeleteStockForm();
        default:
          return const AddStockForm();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: SafeArea(
        child: Column(
          children: [
            // Header (tidak berubah)
            // ...

            // Segmented Control (dengan 4 pilihan)
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
                fillColor: const Color(0xFF6AC0BD),
                selectedColor: Colors.white,
                color: const Color(0xFF1D4A4B),
                borderRadius: BorderRadius.circular(10),
                borderWidth: 0,
                constraints: BoxConstraints.expand(width: (MediaQuery.of(context).size.width - 52) / 4, height: 45), // Dibagi 4
                children: const <Widget>[
                  Text('Tambah', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Pembelian', style: TextStyle(fontWeight: FontWeight.bold)),
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
