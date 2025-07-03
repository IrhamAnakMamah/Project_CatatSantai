import 'package:catatsantai/views/notifikasi/notification_page.dart';
import 'package:catatsantai/views/pengaturan/profile_page.dart';
import 'package:catatsantai/views/pengaturan/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/report_controller.dart';
import '../../controllers/stock_controller.dart';
import '../components/financial_report_page_content.dart';
import 'stock_report_page.dart';

class FinancialReportPage extends StatefulWidget {
  const FinancialReportPage({super.key});

  @override
  State<FinancialReportPage> createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends State<FinancialReportPage> {
  List<bool> _reportTypeSelection = [true, false];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportController>(context, listen: false).fetchLaporan();
      Provider.of<StockController>(context, listen: false).fetchBarang();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildCurrentReportTab() {
      if (_reportTypeSelection[0]) {
        return const FinancialReportPageContent();
      } else {
        return const StockReportPage();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EC),
      body: SafeArea(
        child: Column(
          children: [
            // == HEADER DENGAN IKON-IKON ==
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.settings, color: const Color(0xFF1D4A4B), size: 28),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                  ),
                  Row(children: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: const Color(0xFF1D4A4B), size: 28),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage())),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.person, color: const Color(0xFF1D4A4B), size: 28),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
                    ),
                  ]),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Segmented Control (Keuangan, Stok)
                  Container(
                    width: double.infinity,
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
                          for (int i = 0; i < _reportTypeSelection.length; i++) {
                            _reportTypeSelection[i] = i == index;
                          }
                        });
                      },
                      fillColor: const Color(0xFF6AC0BD),
                      selectedColor: Colors.white,
                      color: const Color(0xFF1D4A4B),
                      borderRadius: BorderRadius.circular(10),
                      borderWidth: 0,
                      constraints: BoxConstraints.expand(width: (MediaQuery.of(context).size.width - 52) / 2, height: 45),
                      children: const <Widget>[
                        Text('Keuangan', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Stok', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Konten akan berganti sesuai tab yang dipilih
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: buildCurrentReportTab(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
