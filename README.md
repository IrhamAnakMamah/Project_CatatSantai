# Catat Santai

Catat Santai adalah aplikasi mobile yang dirancang khusus untuk membantu usaha kecil, khususnya pedagang lansia, dalam mengelola keuangan dan inventaris barang dengan mudah dan terstruktur. Aplikasi ini bertujuan untuk menyederhanakan pencatatan transaksi harian, pemantauan stok, dan pembuatan laporan keuangan sederhana yang sering kali masih dilakukan secara manual dan berdasarkan 'feeling'.

## Daftar Isi

- [Fitur Utama](#fitur-utama)
- [Struktur Proyek](#struktur-proyek)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Persyaratan Sistem](#persyaratan-sistem)
    - [Untuk Pengembangan](#untuk-pengembangan)
    - [Untuk Pengguna](#untuk-pengguna)
- [Database](#database)
- [Instalasi dan Menjalankan Proyek](#instalasi-dan-menjalankan-proyek)
- [Kontribusi](#kontribusi)
- [Lisensi](#lisensi)
- [Tim Pengembang](#tim-pengembang)

## Fitur Utama

Aplikasi Catat Santai menyediakan beberapa fitur inti untuk memudahkan pengelolaan usaha:

* **Registrasi dan Autentikasi Pengguna**: Pengguna dapat mendaftar dengan nomor telepon dan password sederhana, dilengkapi validasi OTP (opsional, direncanakan) untuk kemudahan. [cite_start]Aplikasi akan menyimpan token sesi secara lokal untuk akses otomatis setelah login pertama.
* **Input Data Transaksi**: Memungkinkan pencatatan transaksi (penjualan/pembelian) dengan detail nama barang, jumlah, harga satuan, dan total. [cite_start]Direncanakan fitur *speech-to-text* untuk memudahkan lansia.
* **Manajemen Stok Barang**: Pengguna dapat menambah, mengedit, dan menghapus stok barang. [cite_start]Stok akan diperbarui secara otomatis setelah transaksi, dan sistem akan memberikan peringatan visual/suara untuk stok rendah (<10% dari stok awal).
* **Laporan Keuangan dan Stok**: Menghasilkan laporan dinamis meliputi total pemasukan, pengeluaran, keuntungan bersih, daftar transaksi (harian/mingguan/bulanan), serta jumlah stok barang per kategori. [cite_start]Laporan dioptimalkan untuk performa cepat dan memiliki opsi ekspor ke teks atau WhatsApp.
* [cite_start]**Pencadangan Data Otomatis**: Data lokal akan dicadangkan ke Firebase Firestore setiap hari pukul 00:00 jika perangkat online, dengan sinkronisasi otomatis saat terhubung kembali.

## Struktur Proyek

Struktur direktori utama proyek ini diatur sebagai berikut:
```
catatsantai/
├── android/              # Konfigurasi Android Native
├── ios/                  # Konfigurasi iOS Native
├── lib/                  # Kode sumber utama aplikasi Flutter
│   ├── controllers/      # Logika bisnis dan manajemen state (menggunakan Provider)
│   │   ├── auth_controller.dart
│   │   ├── category_controller.dart
│   │   └── stock_controller.dart
│   ├── models/           # Definisi model data (Barang, Kategori, Pengguna, Transaksi, Detail Transaksi)
│   │   ├── barang_model.dart
│   │   ├── detail_transaksi_model.dart
│   │   ├── kategori_model.dart
│   │   ├── pengguna_model.dart
│   │   └── transaksi_model.dart
│   ├── services/         # Layanan untuk interaksi database (SQLite)
│   │   └── sqlite_service.dart
│   ├── views/            # Komponen UI dan halaman aplikasi
│   │   ├── auth/         # Halaman terkait autentikasi (Login, Signup, Forgot Password, dll.)
│   │   ├── components/   # Widget UI yang dapat digunakan kembali (dialog, intro screen, dll.)
│   │   ├── laporan/      # Halaman laporan (Keuangan, Stok)
│   │   ├── notifikasi/   # Halaman notifikasi
│   │   ├── pengaturan/   # Halaman pengaturan (Profil, Logout)
│   │   ├── stok/         # Halaman manajemen stok (Tambah, Edit, Hapus)
│   │   └── transaksi/    # Halaman pencatatan transaksi
│   └── main.dart         # Titik masuk utama aplikasi
├── linux/                # Konfigurasi Linux Desktop
├── macos/                # Konfigurasi macOS Desktop
├── test/                 # File untuk pengujian
├── web/                  # Konfigurasi Web
├── windows/              # Konfigurasi Windows Desktop
└── pubspec.yaml          # File konfigurasi dependensi dan metadata proyek Flutter
```
## Teknologi yang Digunakan

* **Framework**: Flutter (Dart)
* **Database**:
    * SQLite (untuk penyimpanan data lokal/offline)
    * Firebase Firestore (untuk pencadangan data cloud)
* **State Management**: Provider
* **IDE**: Android Studio (utama), VS Code (opsional)
* **Version Control**: GitHub/GitLab

## Persyaratan Sistem

### Untuk Pengembangan

* **Hardware**:
    * Laptop dengan prosesor min. Intel i5 / AMD Ryzen 5
    * RAM 8GB (disarankan 16GB)
    * SSD 256GB
* **Software**:
    * Android Studio
    * Flutter SDK
    * Git

### Untuk Pengguna

* **Smartphone Android**:
    * Minimal Android 7.0
    * RAM 2GB+
    * Penyimpanan kosong minimal 8GB
    * Layar minimal 5.5 inci

## Database

Aplikasi ini menggunakan kombinasi SQLite untuk penyimpanan data lokal dan Firebase Firestore untuk pencadangan cloud. Berikut adalah skema Entity Relationship Diagram (ERD) dan tabel yang digunakan:

**Entitas dan Atribut Utama:**

* **Pengguna**: `id_pengguna` (PK), `nomor_telepon` (UNIQUE), `password`, `kode_keamanan` (opsional)
* **Profil_Usaha**: `id_profil_usaha` (PK), `id_pengguna` (FK), `nama_usaha`, `alamat`
* **Kategori**: `id_kategori` (PK), `nama_kategori` (UNIQUE)
* **Barang**: `id_barang` (PK), `id_kategori` (FK), `nama_barang`, `stok`, `harga`
* **Transaksi**: `id_transaksi` (PK), `id_pengguna` (FK), `tanggal`, `jenis_transaksi` (`Penjualan`/`Pembelian`), `total`
* **Detail_Transaksi**: `id_detail_transaksi` (PK), `id_transaksi` (FK), `id_barang` (FK), `jumlah`, `harga_satuan`, `subtotal`

**Relasi Antar Entitas:**

* Pengguna 1 : 1 Profil Usaha
* Pengguna 1 : N Transaksi
* Kategori 1 : N Barang
* Barang 1 : N Detail Transaksi
* Transaksi 1 : N Detail Transaksi

## Instalasi dan Menjalankan Proyek

Untuk menjalankan proyek ini di lingkungan pengembangan Anda:

1.  **Clone repositori:**
    ```bash
    git clone https://github.com/IrhamAnakMamah/Project_CatatSantai
    cd project_catatsantai
    ```
2.  **Dapatkan dependensi Flutter:**
    ```bash
    flutter pub get
    ```
3.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

Pastikan Anda telah menginstal Flutter SDK dan mengonfigurasi lingkungan pengembangan Anda (Android Studio/VS Code) dengan benar.

## Kontribusi

Kami menggunakan metodologi pengembangan **Agile** dengan iterasi 2 mingguan. Setiap iterasi melibatkan pembagian pekerjaan, implementasi fitur, demo kepada pengguna (pedagang lansia), dan perbaikan berdasarkan umpan balik.

Jika Anda ingin berkontribusi, silakan ikuti langkah-langkah berikut:

1.  Fork repositori ini.
2.  Buat branch baru untuk fitur Anda (`git checkout -b feature/nama-fitur-baru`).
3.  Lakukan perubahan Anda dan commit (`git commit -m 'feat: tambahkan fitur X'`).
4.  Push ke branch Anda (`git push origin feature/nama-fitur-baru`).
5.  Buat Pull Request.

## Lisensi

[TBD: Tambahkan informasi lisensi di sini, misalnya MIT, Apache 2.0, dll.]

## Tim Pengembang

Proyek ini dikembangkan oleh:

* Muhammad Irham Hadi Putra (123230042)
* Muhammad Dira Raharja (123230052) 
