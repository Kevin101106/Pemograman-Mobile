# FreshTrack 🥬

## 1. Deskripsi Aplikasi

FreshTrack adalah aplikasi mobile untuk membantu pengguna mencatat dan memantau makanan yang disimpan di kulkas. Aplikasi ini membantu pengguna mengetahui tanggal penyimpanan dan batas penggunaan makanan agar makanan tidak mudah terlupakan.

Target pengguna FreshTrack adalah mahasiswa atau anak kos, pengguna meal prep, dan rumah tangga.

## 2. Fitur Aplikasi

- **Register dan Login:** Pengguna dapat membuat akun dan masuk ke aplikasi.
- **Tambah Makanan:** Menambahkan nama, kategori, jumlah, tanggal penyimpanan, tanggal batas penggunaan, dan lokasi makanan.
- **Daftar Makanan:** Melihat seluruh makanan yang telah ditambahkan.
- **Edit dan Hapus:** Mengubah atau menghapus data makanan.
- **Status Makanan:** Menampilkan status Fresh, Use Soon, dan Past Due.
- **Pencarian dan Filter:** Mencari makanan berdasarkan nama, kategori, dan lokasi.
- **Pengurutan:** Mengurutkan makanan berdasarkan tanggal batas penggunaan.
- **Profil:** Melihat informasi akun pengguna.

Status makanan ditentukan berdasarkan tanggal yang dimasukkan pengguna dan bukan merupakan penilaian keamanan makanan.

## 3. Teknologi yang Digunakan

| Bagian | Teknologi |
|---|---|
| Frontend | Flutter dan Dart |
| Backend | Laravel 12 dan PHP |
| Database | MySQL |
| Autentikasi | Laravel Sanctum |
| Penyimpanan token | Flutter Secure Storage |
| Komunikasi | REST API |

## 4. Persiapan Instalasi

Pastikan perangkat sudah memiliki:

- Git
- PHP 8.2 atau lebih baru
- Composer
- MySQL atau XAMPP
- Flutter SDK
- Android Studio dan Android Emulator

## 5. Cara Clone Repository

Buka terminal dan jalankan:

```bash
git clone https://github.com/Kevin101106/Pemograman-Mobile.git
cd Pemograman-Mobile
```

## 6. Instalasi Backend

Masuk ke folder backend:

```bash
cd backend
```

Pasang dependency Laravel:

```bash
composer install
```

Buat file konfigurasi lokal:

```bash
copy .env.example .env
```

Buka file `.env`, kemudian sesuaikan konfigurasi database:

```env
APP_NAME=FreshTrack
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=freshtrack_db
DB_USERNAME=root
DB_PASSWORD=
```

Buat database bernama `freshtrack_db` melalui phpMyAdmin atau MySQL.

Buat application key:

```bash
php artisan key:generate
```

Jalankan migration:

```bash
php artisan migrate
```

Jalankan backend:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

Backend akan berjalan pada port 8000.

## 7. Instalasi Frontend

Buka terminal baru, kemudian masuk ke folder frontend:

```bash
cd frontend
```

Pasang dependency Flutter:

```bash
flutter pub get
```

Untuk menjalankan aplikasi menggunakan Android Emulator, pastikan emulator sudah aktif.

Alamat API untuk Android Emulator adalah:

```text
http://10.0.2.2:8000/api
```

Alamat tersebut digunakan untuk menghubungkan emulator dengan backend yang berjalan di komputer yang sama.

Jalankan aplikasi:

```bash
flutter run
```

## 8. Menjalankan Pengujian

Pengujian backend:

```bash
cd backend
php artisan test
```

Pemeriksaan dependency backend:

```bash
composer audit
```

Pengujian frontend:

```bash
cd frontend
flutter analyze
flutter test
```

## 9. Build Aplikasi Android

Pastikan backend sudah berjalan dan konfigurasi alamat API sesuai dengan lingkungan pengujian.

Masuk ke folder frontend:

```bash
cd frontend
```

Jalankan perintah build:

```bash
flutter build apk --release
```

File APK akan tersedia di:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Untuk memasang APK melalui perangkat yang terhubung dengan ADB:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

**Catatan:** Konfigurasi API saat ini masih menggunakan alamat khusus Android Emulator untuk pengembangan lokal. Agar APK dapat digunakan di luar lingkungan tersebut, alamat API harus diarahkan ke server yang dapat diakses perangkat dan menggunakan HTTPS.

## 10. Konfigurasi untuk Deployment

Sebelum aplikasi dipublikasikan, backend perlu menggunakan server yang dapat diakses melalui internet.

Konfigurasi produksi Laravel harus menggunakan:

```env
APP_ENV=production
APP_DEBUG=false
```

Selain itu, alamat API frontend harus diarahkan ke alamat server produksi dengan HTTPS. Konfigurasi database dan kredensial server juga harus disesuaikan dengan lingkungan produksi.

Deployment publik belum termasuk dalam konfigurasi pengembangan lokal yang dijelaskan di atas.

## 11. Dokumentasi Tambahan

Dokumentasi proyek tersedia pada file berikut:

- [HowToRun.md](HowToRun.md) — Panduan menjalankan aplikasi.
- [checklist_mvp.md](checklist_mvp.md) — Checklist penyelesaian MVP.
- [SECURITY_TEST.md](SECURITY_TEST.md) — Hasil pengujian keamanan.
- [demo.mp4](demo.mp4) — Video demonstrasi aplikasi.

## 12. Batasan Aplikasi

FreshTrack berfokus pada pencatatan dan pemantauan makanan. Aplikasi ini belum menyediakan fitur AI, kamera pendeteksi kondisi makanan, sensor IoT, marketplace, pembayaran, GPS, maupun chat antar pengguna.