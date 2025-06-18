import '../components/financial_report_page_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/report_controller.dart';
import '../../controllers/stock_controller.dart';
import 'stock_report_page.dart';

// 1. Diubah menjadi StatefulWidget agar kita bisa menggunakan initState.
class FinancialReportPage extends StatefulWidget {
  const FinancialReportPage({super.key});

  @override
  State<FinancialReportPage> createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends State<FinancialReportPage> {
  // State untuk mengelola tab yang aktif (Keuangan atau Stok)
  List<bool> _reportTypeSelection = [true, false];

  @override
  void initState() {
    super.initState();
    // 2. Saat halaman pertama kali dibuka, panggil fungsi untuk mengambil data.
    // Ini adalah langkah kunci untuk memastikan data selalu fresh.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportController>(context, listen: false).fetchLaporan();
      Provider.of<StockController>(context, listen: false).fetchBarang();
    });
  }

  @override
  Widget build(BuildContext context) {
    int activeReportTypeIndex = _reportTypeSelection.indexOf(true);

    Widget buildCurrentReportTab() {
      if (activeReportTypeIndex == 0) {
        return const FinancialReportPageContent();
      } else {
        return const StockReportPage();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      // Kita gunakan AppBar agar ada judul yang jelas
      appBar: AppBar(
        title: Text('Laporan', style: TextStyle(color: const Color(0xFF1D4A4B), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali otomatis
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            // Segmented Control (Keuangan, Stok)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
                ],
              ),
              child: ToggleButtons(
                isSelected: _reportTypeSelection,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0; buttonIndex < _reportTypeSelection.length; buttonIndex++) {
                      _reportTypeSelection[buttonIndex] = (buttonIndex == index);
                    }
                  });
                },
                fillColor: const Color(0xFF6AC0BD),
                selectedColor: Colors.white,
                color: const Color(0xFF1D4A4B),
                borderRadius: BorderRadius.circular(10),
                borderWidth: 0,
                constraints: BoxConstraints.expand(width: (MediaQuery.of(context).size.width - 48 - 4) / 2, height: 45),
                children: const <Widget>[
                  Text('Keuangan', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Stok', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20), // Memberi jarak antara tab dan konten

            // Konten akan berganti sesuai tab yang dipilih
            Expanded(
              child: buildCurrentReportTab(),
            ),
          ],
        ),
      ),
    );
  }
}
