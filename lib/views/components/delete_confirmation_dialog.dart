import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  // Fungsi yang akan dipanggil jika user menekan tombol 'Hapus'
  final VoidCallback onDeleteConfirmed;

  const DeleteConfirmationDialog({super.key, required this.onDeleteConfirmed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Bentuk dialog dengan sudut membulat
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent, // Background transparan agar konten Card yang terlihat
      child: Stack( // Menggunakan Stack untuk menumpuk icon di atas card
        clipBehavior: Clip.none, // Memungkinkan widget di luar batas Stack terlihat
        children: <Widget>[
          // Card putih sebagai background dialog
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            margin: const EdgeInsets.only(top: 45), // Memberi ruang untuk icon di atas
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar kolom mengambil tinggi minimum
              children: <Widget>[
                const SizedBox(height: 50), // Jarak dari atas untuk icon
                Text(
                  'Yakin ingin menghapus\ndata ini?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D4A4B), // Warna teks gelap
                  ),
                ),
                const SizedBox(height: 30),
                // Tombol Hapus
                SizedBox(
                  width: double.infinity, // Lebar penuh
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog dulu
                      onDeleteConfirmed(); // Panggil fungsi konfirmasi hapus
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600], // Warna merah untuk tombol hapus
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5, // Bayangan tombol
                    ),
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Tombol Batal
                SizedBox(
                  width: double.infinity, // Lebar penuh
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1D4A4B), // Warna teks
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: const Color(0xFFD9D9D9), width: 1.5), // Border abu-abu
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D4A4B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Icon tanda tanya di atas dialog
          Positioned(
            left: 0,
            right: 0,
            top: 0, // Posisikan di bagian paling atas Stack
            child: CircleAvatar(
              backgroundColor: Colors.white, // Background putih untuk avatar
              radius: 45,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red[600]!, // Warna border merah
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.question_mark, // Icon tanda tanya
                    color: Colors.red[600], // Warna icon merah
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
