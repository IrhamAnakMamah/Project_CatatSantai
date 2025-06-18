import 'package:flutter/material.dart';
import 'package:catatsantai/views/stok/add_stock_form.dart'; // Import form Tambah Stok
import 'package:catatsantai/views/stok/edit_stock_form.dart'; // Import form Edit Stok
import 'package:catatsantai/views/stok/delete_stock_form.dart'; // Import form Hapus Stok

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  // State for segmented control (Tambah, Edit, Hapus)
  // 0: Tambah, 1: Edit, 2: Hapus
  List<bool> _isSelected = [true, false, false]; // Default: Tambah aktif

  @override
  Widget build(BuildContext context) {
    // Determine the active tab index
    int activeTabIndex = _isSelected.indexOf(true);

    // Helper widget to build the current form based on the active tab
    Widget _buildCurrentForm() {
      if (activeTabIndex == 0) {
        return const AddStockForm();
      } else if (activeTabIndex == 1) {
        return const EditStockForm();
      } else { // activeTabIndex == 2 (Hapus)
        return const DeleteStockForm();
      }
    }

    return Scaffold(
      // Page background color, similar to the Figma design
      backgroundColor: const Color(0xFFF7F5EC), // Light cream color
      body: SafeArea( // To avoid overlap with the status bar
        child: Column(
          children: [
            // Header (Gear, Notification, User icons)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.settings, color: const Color(0xFF1D4A4B), size: 28),
                  Row(
                    children: [
                      Icon(Icons.notifications, color: const Color(0xFF1D4A4B), size: 28),
                      const SizedBox(width: 16),
                      Icon(Icons.person, color: const Color(0xFF1D4A4B), size: 28),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Segmented Control (Tambah, Edit, Hapus)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ToggleButtons(
                isSelected: _isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0; buttonIndex < _isSelected.length; buttonIndex++) {
                      _isSelected[buttonIndex] = (buttonIndex == index);
                    }
                  });
                },
                fillColor: const Color(0xFF6AC0BD), // Color when selected
                selectedColor: Colors.white, // Text color when selected
                color: const Color(0xFF1D4A4B), // Text color when not selected
                splashColor: const Color(0xFF6AC0BD).withOpacity(0.3),
                highlightColor: const Color(0xFF6AC0BD).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                borderWidth: 0, // Remove default ToggleButtons border
                constraints: BoxConstraints.expand(width: (MediaQuery.of(context).size.width - 48 - 20) / 3, height: 45), // Adjust width
                children: const <Widget>[
                  Text('Tambah', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Active form (Tambah, Edit, or Hapus)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildCurrentForm(), // Call the appropriate form
              ),
            ),
          ],
        ),
      ),
    );
  }
}