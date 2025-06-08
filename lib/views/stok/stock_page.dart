import 'package:flutter/material.dart';
import 'package:catatsantai/views/stok/add_stock_form.dart'; // Import form Tambah Stok
import 'package:catatsantai/views/stok/edit_stock_form.dart'; // Import form Edit Stok
import 'package:catatsantai/views/stok/delete_stock_form.dart'; // Import form Hapus Stok
// import 'package:catatsantai/assets/transaction_success_dialog.dart'; // Jika ingin menampilkan dialog sukses

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
      body: Stack(
        children: [
          // Background shapes (circles and plus signs) - consistent with previous pages
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF4FC0BD).withOpacity(0.8), // Tosca
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 60,
                color: const Color(0xFF1D4A4B).withOpacity(0.3), // Darker tosca, semi-transparent
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 40,
                color: const Color(0xFF1D4A4B).withOpacity(0.3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF4FC0BD).withOpacity(0.5), // Tosca, semi-transparent
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main page content
          SafeArea( // To avoid overlap with the status bar
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

                // Bottom Navigation Bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBottomNavItem(Icons.receipt_long, 'catat transaksi', false),
                      _buildBottomNavItem(Icons.inventory_2, 'catat stok', true), // Active here
                      _buildBottomNavItem(Icons.bar_chart, 'Laporan', false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for building bottom navigation bar items
  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF1D4A4B) : Colors.grey[600], // Active/inactive color
          size: 28,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF1D4A4B) : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
