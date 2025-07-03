import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaksi_model.dart';
import '../../controllers/report_controller.dart';

class ReportDetailsDialog extends StatelessWidget {
  final List<Transaksi> transactions;
  final ReportPeriod period;

  const ReportDetailsDialog({
    super.key,
    required this.transactions,
    required this.period,
  });

  String _getPeriodTitle(ReportPeriod period) {
    switch (period) {
      case ReportPeriod.harian: return 'Harian';
      case ReportPeriod.mingguan: return 'Mingguan';
      case ReportPeriod.bulanan: return 'Bulanan';
      case ReportPeriod.tahunan: return 'Tahunan';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    // Formatter untuk tanggal dan waktu
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    return AlertDialog(
      title: Text('Detail Laporan ${_getPeriodTitle(period)}'),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        child: transactions.isEmpty
            ? const Center(child: Text('Tidak ada transaksi untuk periode ini.'))
            : ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final trx = transactions[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bagian yang menampilkan jenis dan total transaksi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          trx.jenisTransaksi,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: trx.jenisTransaksi == 'Penjualan' ? const Color(0xFF1D4A4B) : Colors.red[600],
                          ),
                        ),
                        Text(
                          currencyFormatter.format(trx.total),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: trx.jenisTransaksi == 'Penjualan' ? const Color(0xFF1D4A4B) : Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // === INI BAGIAN YANG HILANG: MENAMPILKAN TANGGAL ===
                    Text(
                      dateFormatter.format(trx.tanggal),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    // ===================================================

                    const SizedBox(height: 12),
                    const Divider(height: 1, thickness: 0.5),
                    const SizedBox(height: 12),
                    const Text('Detail Barang:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    if (trx.details.isEmpty)
                      const Text('Tidak ada detail barang.', style: TextStyle(fontSize: 12, color: Colors.grey))
                    else
                      ...trx.details.map((detail) {
                        final namaBarang = detail.namaBarang ?? 'Barang Dihapus';
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            '$namaBarang: ${detail.jumlah} x ${currencyFormatter.format(detail.hargaSatuan)} = ${currencyFormatter.format(detail.subtotal)}',
                            style: TextStyle(
                                fontSize: 12,
                                color: detail.namaBarang != null
                                    ? Colors.grey[800]
                                    : Colors.red.withOpacity(0.8)
                            ),
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Tutup'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}