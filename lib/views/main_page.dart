import 'package:flutter/material.dart';
// Impor semua halaman utama yang akan dinavigasikan
import 'transaksi/transaction_page.dart';
import 'stok/stock_page.dart';
import 'laporan/financial_report_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // State untuk melacak halaman mana yang sedang aktif.
  // 0 = Transaksi, 1 = Stok, 2 = Laporan
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai dengan indeks di atas.
  // Pastikan urutannya sesuai dengan urutan item di BottomNavigationBar.
  static const List<Widget> _pages = <Widget>[
    TransactionPage(),
    StockPage(),
    FinancialReportPage(),
  ];

  // Fungsi ini akan dipanggil saat salah satu item navigasi ditekan.
  // Ia akan mengubah state _selectedIndex, yang kemudian akan memicu build ulang
  // untuk menampilkan halaman yang benar.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bagian body akan secara dinamis menampilkan halaman dari daftar _pages
      // berdasarkan _selectedIndex yang sedang aktif.
      body: _pages[_selectedIndex],

      // Ini adalah bilah navigasi bawah Anda.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Memberi tahu item mana yang harus disorot
        onTap: _onItemTapped, // Menghubungkan aksi tap ke fungsi kita

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
