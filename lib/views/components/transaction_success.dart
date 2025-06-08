import 'package:flutter/material.dart';

class TransactionSuccessDialog extends StatelessWidget {
  const TransactionSuccessDialog({super.key});

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
            padding: const EdgeInsets.all(20),
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
                const SizedBox(height: 60), // Jarak dari atas untuk icon
                Text(
                  'Data Tersimpan!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D4A4B), // Warna teks gelap
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A8EEB), // Warna biru tombol
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5, // Bayangan tombol
                    ),
                    child: Text(
                      'Oke',
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
          // Icon centang di atas dialog
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
                    color: const Color(0xFF6A8EEB), // Warna border biru
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: const Color(0xFF6A8EEB), // Warna icon centang biru
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
