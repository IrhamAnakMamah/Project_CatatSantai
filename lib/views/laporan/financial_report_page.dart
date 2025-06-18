import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Impor paket intl
import 'package:provider/provider.dart';
import '../../controllers/report_controller.dart';

class FinancialReportPageContent extends StatelessWidget {
  const FinancialReportPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer untuk "mendengarkan" perubahan dari ReportController
    return Consumer<ReportController>(
      builder: (context, controller, child) {
        // Helper untuk format mata uang Rupiah
        final currencyFormatter = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown untuk filter periode waktu
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150,
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
                  child: DropdownButton<ReportPeriod>(
                    // Nilai dropdown diambil dari controller
                    value: controller.selectedPeriod,
                    icon: Icon(Icons.keyboard_arrow_down, color: const Color(0xFF1D4A4B)),
                    style: TextStyle(
                      color: const Color(0xFF1D4A4B),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    // Saat nilai diubah, panggil fungsi changePeriod di controller
                    onChanged: (ReportPeriod? newValue) {
                      if (newValue != null) {
                        controller.changePeriod(newValue);
                      }
                    },
                    // Membuat daftar item dropdown dari enum ReportPeriod
                    items: ReportPeriod.values.map<DropdownMenuItem<ReportPeriod>>((ReportPeriod value) {
                      String text;
                      switch (value) {
                        case ReportPeriod.harian: text = 'Harian'; break;
                        case ReportPeriod.mingguan: text = 'Mingguan'; break;
                        case ReportPeriod.bulanan: text = 'Bulanan'; break;
                        case ReportPeriod.tahunan: text = 'Tahunan'; break;
                      }
                      return DropdownMenuItem<ReportPeriod>(
                        value: value,
                        child: Text(text),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Tampilkan loading indicator jika sedang memuat data
            if (controller.isLoading)
              const Center(child: CircularProgressIndicator())
            else
            // Jika tidak loading, tampilkan data keuangan
              Column(
                children: [
                  // Baris Pemasukan
                  _buildReportRow(
                    label: 'Pemasukan',
                    // Ambil nilai pemasukan dari controller dan format
                    amount: currencyFormatter.format(controller.pemasukan),
                    amountColor: const Color(0xFF1D4A4B),
                  ),
                  const Divider(height: 30, thickness: 1, color: Colors.grey),

                  // Baris Pengeluaran
                  _buildReportRow(
                    label: 'Pengeluaran',
                    // Ambil nilai pengeluaran dari controller dan format
                    amount: currencyFormatter.format(controller.pengeluaran),
                    amountColor: Colors.red[600]!,
                  ),
                  const Divider(height: 30, thickness: 1, color: Colors.grey),

                  // Baris Keuntungan
                  _buildReportRow(
                    label: 'Keuntungan',
                    // Ambil nilai keuntungan dari controller dan format
                    amount: currencyFormatter.format(controller.keuntungan),
                    amountColor: const Color(0xFF6AC0BD),
                  ),
                  const Divider(height: 30, thickness: 1, color: Colors.grey),
                ],
              ),
          ],
        );
      },
    );
  }

  // Helper method untuk membangun baris laporan (tidak berubah)
  Widget _buildReportRow({required String label, required String amount, required Color amountColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF1D4A4B)),
        ),
        Text(
          amount,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: amountColor),
        ),
      ],
    );
  }
}
