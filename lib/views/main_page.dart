import 'package:flutter/material.dart';
import 'transaksi/transaction_page.dart'; // Impor halaman transaksi
import 'stok/stock_page.dart';           // Impor halaman stok
import 'laporan/financial_report_page.dart'; // Impor halaman laporan

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // State untuk melacak halaman mana yang sedang aktif.
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai dengan indeks.
  static const List<Widget> _pages = <Widget>[
    TransactionPage(),
    StockPage(),
    FinancialReportPage(),
  ];

  // Fungsi yang akan dipanggil saat item di navigasi bar ditekan.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan menampilkan halaman yang sesuai dari daftar _pages.
      body: _pages[_selectedIndex],

      // Ini adalah bilah navigasi bawah Anda.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Memberi tahu item mana yang aktif
        onTap: _onItemTapped, // Fungsi yang dipanggil saat item ditekan

        // Styling agar sesuai dengan desain Anda
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1D4A4B),
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

        // Daftar item di navigasi bar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Catat Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Catat Stok',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Laporan',
          ),
        ],
      ),
    );
  }
}
