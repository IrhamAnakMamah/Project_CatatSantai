import 'package:flutter/material.dart';

// This widget displays the stock report content (list of items and quantities).
class StockReportPage extends StatelessWidget {
  const StockReportPage({super.key});

  // Example data for stock report
  final List<Map<String, String>> _stockItems = const [
    {'name': 'Daging', 'quantity': '10 Unit'},
    {'name': 'Sawi', 'quantity': '10 Unit'},
    {'name': 'Bawang', 'quantity': '10 Unit'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Stok',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D4A4B),
              ),
            ),
            Text(
              'Jumlah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D4A4B),
              ),
            ),
          ],
        ),
        const Divider(height: 30, thickness: 1, color: Colors.grey), // Divider after header

        // List of stock items
        ..._stockItems.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['name']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF1D4A4B),
                      ),
                    ),
                    Text(
                      item['quantity']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF1D4A4B),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16, thickness: 0.5, color: Colors.grey), // Divider between items
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
