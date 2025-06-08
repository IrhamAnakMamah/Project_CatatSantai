import 'package:flutter/material.dart';
import 'package:catatsantai/views/components/financial_report_page_content.dart'; // Import the financial report content
import 'package:catatsantai/views/laporan/stock_report_page.dart'; // Import the stock report content

// This is the main report page with "Keuangan" and "Stok" tabs.
class FinancialReportPage extends StatefulWidget {
  const FinancialReportPage({super.key});

  @override
  State<FinancialReportPage> createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends State<FinancialReportPage> {
  // State for segmented control (Keuangan, Stok)
  // 0: Keuangan, 1: Stok
  List<bool> _reportTypeSelection = [true, false]; // Default: Keuangan is active

  @override
  Widget build(BuildContext context) {
    // Determine the active report type tab index
    int activeReportTypeIndex = _reportTypeSelection.indexOf(true);

    // Helper widget to build the current report tab based on the active tab
    Widget _buildCurrentReportTab() {
      if (activeReportTypeIndex == 0) {
        return const FinancialReportPageContent(); // Display Financial Report Content
      } else { // activeReportTypeIndex == 1 (Stok)
        return const StockReportPage(); // Display Stock Report Page
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

                // Segmented Control (Keuangan, Stok)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
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
                      isSelected: _reportTypeSelection,
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0; buttonIndex < _reportTypeSelection.length; buttonIndex++) {
                            _reportTypeSelection[buttonIndex] = (buttonIndex == index);
                          }
                          // TODO: Add logic to load data based on tab (Keuangan/Stok)
                          print('Report Tab: ${['Keuangan', 'Stok'][index]}');
                        });
                      },
                      fillColor: const Color(0xFF6AC0BD), // Color when selected
                      selectedColor: Colors.white, // Text color when selected
                      color: const Color(0xFF1D4A4B), // Text color when not selected
                      splashColor: const Color(0xFF6AC0BD).withOpacity(0.3),
                      highlightColor: const Color(0xFF6AC0BD).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      borderWidth: 0, // Remove default ToggleButtons border
                      constraints: BoxConstraints.expand(width: (MediaQuery.of(context).size.width - 48 - 20) / 2, height: 45), // Adjust width
                      children: const <Widget>[
                        Text('Keuangan', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Stok', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Content based on selected tab (Keuangan or Stok)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildCurrentReportTab(), // Call the appropriate tab content
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
                      _buildBottomNavItem(Icons.inventory_2, 'catat stok', false),
                      _buildBottomNavItem(Icons.bar_chart, 'Laporan', true), // Active here
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
