import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../controllers/report_controller.dart';
import '../laporan/report_details_dialog.dart'; // Impor dialog detail laporan yang akan kita buat

class FinancialReportPageContent extends StatelessWidget {
  const FinancialReportPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportController>(
      builder: (context, controller, child) {
        final currencyFormatter = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ReportPeriod>(
                    value: controller.selectedPeriod,
                    icon: Icon(Icons.keyboard_arrow_down, color: const Color(0xFF1D4A4B)),
                    style: TextStyle(color: const Color(0xFF1D4A4B), fontSize: 16, fontWeight: FontWeight.bold),
                    onChanged: (ReportPeriod? newValue) {
                      if (newValue != null) {
                        controller.changePeriod(newValue);
                      }
                    },
                    items: ReportPeriod.values.map<DropdownMenuItem<ReportPeriod>>((ReportPeriod value) {
                      String text;
                      switch (value) {
                        case ReportPeriod.harian: text = 'Harian'; break;
                        case ReportPeriod.mingguan: text = 'Mingguan'; break;
                        case ReportPeriod.bulanan: text = 'Bulanan'; break;
                        case ReportPeriod.tahunan: text = 'Tahunan'; break;
                      }
                      return DropdownMenuItem<ReportPeriod>(value: value, child: Text(text));
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            if (controller.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Column(
                children: [
                  _buildReportRow(
                    label: 'Pemasukan',
                    amount: currencyFormatter.format(controller.pemasukan),
                    amountColor: const Color(0xFF1D4A4B),
                  ),
                  const Divider(height: 30, thickness: 1, color: Colors.grey),
                  _buildReportRow(
                    label: 'Pengeluaran',
                    amount: currencyFormatter.format(controller.pengeluaran),
                    amountColor: Colors.red[600]!,
                  ),
                  const Divider(height: 30, thickness: 1, color: Colors.grey),
                  _buildReportRow(
                    label: 'Keuntungan',
                    amount: currencyFormatter.format(controller.keuntungan),
                    amountColor: const Color(0xFF6AC0BD),
                  ),
                  const Divider(height: 30, thickness: 1, color: Colors.grey),
                  const SizedBox(height: 30), // Spasi sebelum tombol

                  // Tombol "Lihat Detail Laporan"
                  Align(
                    alignment: Alignment.center, // Pusatkan tombol
                    child: ElevatedButton(
                      onPressed: () {
                        // Tampilkan dialog detail laporan
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return ReportDetailsDialog(
                              transactions: controller.transactions, // Meneruskan daftar transaksi
                              period: controller.selectedPeriod,
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A8EEB), // Warna biru tombol
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Lihat Detail Laporan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildReportRow({required String label, required String amount, required Color amountColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B))),
        Text(amount, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: amountColor)),
      ],
    );
  }
}