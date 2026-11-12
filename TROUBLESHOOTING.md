# Troubleshooting FreshTrack

Dokumen ini berisi beberapa masalah yang mungkin terjadi saat menjalankan FreshTrack beserta penyebab dan cara mengatasinya.

## 1. Backend Tidak Bisa Dijalankan

**Contoh pesan:**

```text
Failed to listen on 0.0.0.0:8000
```

**Penyebab:**
Port 8000 sedang digunakan oleh proses lain.

**Solusi:**
- Periksa apakah Laravel sudah berjalan di terminal lain.
- Jika perlu, gunakan port lain dan sesuaikan alamat API frontend.

## 2. Database Tidak Terhubung

**Contoh pesan:**

```text
SQLSTATE[HY000] [2002] Connection refused
```

**Penyebab:**
MySQL belum aktif atau konfigurasi database tidak sesuai.

**Solusi:**
- Aktifkan MySQL melalui XAMPP.
- Pastikan database `freshtrack_db` sudah dibuat.
- Periksa konfigurasi database pada file `.env`.

## 3. API Tidak Bisa Diakses dari Emulator

**Contoh pesan:**

```text
Connection refused
```

**Penyebab:**
Backend belum berjalan atau alamat API tidak sesuai.

**Solusi:**
- Jalankan Laravel pada port 8000.
- Pastikan alamat API Android Emulator menggunakan `10.0.2.2`, bukan `localhost`.
- Pastikan emulator dapat mengakses backend.

## 4. Gagal Login

**Contoh pesan:**

```text
Email atau password salah
```

**Penyebab:**
Email atau password tidak sesuai dengan akun yang terdaftar.

**Solusi:**
- Periksa kembali email dan password.
- Jika belum memiliki akun, lakukan registrasi terlebih dahulu.

## 5. Tidak Bisa Mengakses Data Makanan

**Contoh pesan:**

```text
401 Unauthorized
```

**Penyebab:**
Token autentikasi tidak tersedia, tidak valid, atau sesi sudah berakhir.

**Solusi:**
- Login kembali ke aplikasi.
- Periksa koneksi backend.
- Pastikan token dikirim melalui header Authorization.

## 6. Migration Database Gagal

**Contoh pesan:**

```text
Migration failed
```

**Penyebab:**
Database belum tersedia atau struktur tabel mengalami masalah.

**Solusi:**
- Pastikan MySQL aktif.
- Periksa nama database pada `.env`.
- Jalankan `php artisan migrate` kembali setelah masalah diperbaiki.

## 7. Flutter Dependency Bermasalah

**Contoh pesan:**

```text
Package not found
```

**Penyebab:**
Dependency Flutter belum terpasang atau proses pengunduhan paket terganggu.

**Solusi:**
Masuk ke folder frontend dan jalankan:

```bash
flutter pub get
```

## 8. Pengujian Flutter Gagal

**Contoh pesan:**

```text
Some tests failed
```

**Penyebab:**
Ada pengujian yang tidak sesuai dengan kondisi kode saat ini.

**Solusi:**
- Periksa nama pengujian yang gagal.
- Periksa perubahan kode terakhir.
- Jalankan kembali `flutter test` setelah perbaikan.

## 9. Aturan Log yang Aman

Saat membagikan log untuk pemeriksaan, pastikan informasi berikut tidak ikut dibagikan:

- Password pengguna.
- Token autentikasi.
- APP_KEY Laravel.
- Username dan password database.
- API key dan informasi rahasia lainnya.

Gunakan pesan error yang relevan saja agar masalah dapat diperiksa tanpa membocorkan informasi sensitif.