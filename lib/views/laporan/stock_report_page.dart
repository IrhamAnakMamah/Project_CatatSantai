import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/stock_controller.dart';

class StockReportPage extends StatelessWidget {
  const StockReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer untuk "mendengarkan" perubahan dari StockController
    return Consumer<StockController>(
      builder: (context, controller, child) {
        // Tampilkan loading indicator jika sedang memuat data dan daftar masih kosong
        if (controller.isLoading && controller.barangList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Tampilkan pesan jika tidak ada barang
        if (controller.barangList.isEmpty) {
          return const Center(child: Text('Belum ada data stok barang.'));
        }

        // Tampilkan daftar barang jika data tersedia.
        // UI di bawah ini diambil persis dari kode asli Anda.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Tabel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
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
            ),
            const Divider(height: 1, thickness: 1, color: Colors.grey),

            // Gunakan Expanded agar ListView mengisi sisa ruang yang tersedia
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.barangList.length,
                itemBuilder: (context, index) {
                  final barang = controller.barangList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              barang.namaBarang,
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFF1D4A4B),
                              ),
                            ),
                            Text(
                              '${barang.stok} Unit', // Data dinamis dari controller
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFF1D4A4B),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16, thickness: 0.5, color: Colors.grey),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
