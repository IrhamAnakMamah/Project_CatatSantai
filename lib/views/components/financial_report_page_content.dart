import 'package:flutter/material.dart';

// This widget displays the financial report content (Income, Expenses, Profit).
class FinancialReportPageContent extends StatefulWidget {
  const FinancialReportPageContent({super.key});

  @override
  State<FinancialReportPageContent> createState() => _FinancialReportPageContentState();
}

class _FinancialReportPageContentState extends State<FinancialReportPageContent> {
  String? _selectedTimePeriod = 'Tahunan'; // Default: Tahunan

  // Example data for financial report (can be dynamic later)
  final double _income = 100000000.0;
  final double _expenses = 0.0;
  final double _profit = 100000000.0;

  // List of time periods for the dropdown
  final List<String> _timePeriods = ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Period Dropdown
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 150, // Adjust dropdown width
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTimePeriod,
                icon: Icon(Icons.keyboard_arrow_down, color: const Color(0xFF1D4A4B)),
                style: TextStyle(
                  color: const Color(0xFF1D4A4B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTimePeriod = newValue;
                    // TODO: Add logic to load financial data based on time period
                    print('Time Period: $newValue');
                  });
                },
                items: _timePeriods.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Income row
        _buildReportRow('Pemasukan', _income),
        const Divider(height: 30, thickness: 1, color: Colors.grey),

        // Expenses row
        _buildReportRow('Pengeluaran', _expenses, isExpense: true),
        const Divider(height: 30, thickness: 1, color: Colors.grey),

        // Profit row
        _buildReportRow('Keuntungan', _profit, isProfit: true),
        const Divider(height: 30, thickness: 1, color: Colors.grey),
      ],
    );
  }

  // Helper method to build a single report row (Income, Expenses, Profit)
  Widget _buildReportRow(String label, double amount, {bool isExpense = false, bool isProfit = false}) {
    Color amountColor = const Color(0xFF1D4A4B); // Default color
    if (isExpense) {
      amountColor = Colors.red[600]!; // Red for expenses
    } else if (isProfit) {
      amountColor = const Color(0xFF6AC0BD); // Greenish for profit
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D4A4B),
          ),
        ),
        Text(
          'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}', // Rupiah format
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ],
    );
  }
}
