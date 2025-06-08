import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  // Variabel untuk menyimpan nilai dropdown
  String? _selectedItemType;
  String? _selectedItemName;
  // Variabel untuk menyimpan jumlah barang
  int _quantity = 0;
  // Variabel untuk menyimpan total harga (contoh, bisa disesuaikan nanti)
  double _totalPrice = 19000.0; // Sesuai contoh di design

  // List contoh untuk dropdown Jenis barang
  final List<String> _itemTypes = ['Makanan', 'Minuman', 'Pakaian', 'Elektronik'];
  // List contoh untuk dropdown Nama barang (akan disesuaikan berdasarkan jenis barang)
  final Map<String, List<String>> _itemNames = {
    'Makanan': ['Nasi Goreng', 'Mie Ayam', 'Bakso'],
    'Minuman': ['Es Teh', 'Kopi', 'Jus Jeruk'],
    'Pakaian': ['T-Shirt', 'Celana Jeans', 'Jaket'],
    'Elektronik': ['Handphone', 'Laptop', 'Headset'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background halaman, mirip dengan warna di design Figma
      backgroundColor: const Color(0xFFF7F5EC), // Warna krem muda
      body: Stack(
        children: [
          // Background shapes (lingkaran dan tanda plus) - konsisten dengan halaman sebelumnya
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

          // Konten utama halaman
          SafeArea( // Untuk menghindari overlap dengan status bar
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

                // Judul "catat transaksi"
                Column(
                  children: [
                    Text(
                      'catat',
                      style: TextStyle(
                        fontFamily: 'Pacifico', // Sesuaikan jika menggunakan font khusus
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D4A4B),
                      ),
                    ),
                    Text(
                      'transaksi',
                      style: TextStyle(
                        fontFamily: 'Montserrat', // Sesuaikan jika menggunakan font khusus
                        fontSize: 24,
                        letterSpacing: 2,
                        color: const Color(0xFF1D4A4B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Form input
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Jenis barang Dropdown
                        Text(
                          'Jenis barang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1D4A4B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedItemType,
                          hint: const Text('Pilih jenis barang terjual'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          items: _itemTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedItemType = newValue;
                              _selectedItemName = null; // Reset nama barang saat jenis barang berubah
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Nama barang Dropdown
                        Text(
                          'Nama barang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1D4A4B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedItemName,
                          hint: const Text('Pilih nama barang terjual'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: const Color(0xFF4FC0BD), width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: const Color(0xFF4FC0BD).withOpacity(0.7), width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: const Color(0xFF1D4A4B), width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          items: _selectedItemType != null
                              ? _itemNames[_selectedItemType!]?.map((name) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(name),
                            );
                          }).toList()
                              : [], // Kosong jika jenis barang belum dipilih
                          onChanged: (newValue) {
                            setState(() {
                              _selectedItemName = newValue;
                            });
                          },
                          // Nonaktifkan dropdown jika jenis barang belum dipilih
                          // isEnabled: _selectedItemType != null, // isEnabled tidak ada di DropdownButtonFormField
                        ),
                        const SizedBox(height: 20),

                        // Quantity Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Jumlah',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1D4A4B),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9), // Warna abu-abu muda
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Color(0xFF1D4A4B)),
                                    onPressed: () {
                                      setState(() {
                                        if (_quantity > 0) _quantity--;
                                      });
                                    },
                                  ),
                                  Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$_quantity',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1D4A4B),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Color(0xFF1D4A4B)),
                                    onPressed: () {
                                      setState(() {
                                        _quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Total Price Display
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1D4A4B),
                              ),
                            ),
                            Text(
                              'Rp ${_totalPrice.toStringAsFixed(0)}', // Format tanpa desimal
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1D4A4B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Save Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Tambahkan logika untuk menyimpan transaksi
                              print('Tombol Simpan ditekan!');
                              print('Jenis Barang: $_selectedItemType');
                              print('Nama Barang: $_selectedItemName');
                              print('Jumlah: $_quantity');
                              print('Total: $_totalPrice');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6AC0BD), // Warna tosca muda
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5, // Bayangan tombol
                            ),
                            child: Text(
                              'Simpan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                      _buildBottomNavItem(Icons.receipt_long, 'catat transaksi', true),
                      _buildBottomNavItem(Icons.inventory_2, 'catat stok', false),
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
          color: isActive ? const Color(0xFF1D4A4B) : Colors.grey[600], // Warna aktif/nonaktif
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
