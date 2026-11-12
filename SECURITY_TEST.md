# Laporan Pengujian Keamanan FreshTrack

## 1. Tujuan Pengujian

Pengujian ini dilakukan untuk memeriksa keamanan aplikasi FreshTrack, terutama pada bagian login, registrasi, akses data makanan, penyimpanan token, dan keamanan API.

Pengujian dilakukan pada backend Laravel dan frontend Flutter.

## 2. Hasil Pengujian

| No. | Pengujian | Hasil | Keterangan |
|---|---|---|---|
| 1 | Pemeriksaan dependency Composer | Lulus | Tidak ditemukan peringatan kerentanan keamanan. |
| 2 | Perlindungan API | Lulus | API makanan hanya dapat diakses setelah login. |
| 3 | Pembatasan akses data | Lulus | Pengguna hanya dapat melihat data makanan miliknya sendiri. |
| 4 | Pencegahan akses data pengguna lain | Lulus | Pengguna tidak dapat melihat, mengubah, atau menghapus data milik pengguna lain. |
| 5 | Pembatasan percobaan login | Lulus | Login dibatasi 5 permintaan per menit. |
| 6 | Pembatasan registrasi | Lulus | Registrasi dibatasi 5 permintaan per menit. |
| 7 | Perlindungan password | Lulus | Password disimpan dalam bentuk hash dan tidak ditampilkan dalam respons model. |
| 8 | Penyimpanan token | Diperbaiki | Token sekarang disimpan menggunakan Flutter Secure Storage. |
| 9 | Pemeriksaan kode Flutter | Lulus | Tidak ditemukan masalah melalui `flutter analyze`. |
| 10 | Pengujian frontend | Lulus | Sebanyak 34 pengujian berhasil. |
| 11 | Pengujian backend | Lulus | Sebanyak 7 pengujian berhasil dengan 14 pemeriksaan. |

## 3. Perbaikan Keamanan

Beberapa perbaikan yang dilakukan selama pengujian adalah:

1. Menambahkan perlindungan autentikasi menggunakan Laravel Sanctum pada API makanan.
2. Membatasi akses data agar setiap pengguna hanya dapat mengelola makanan miliknya sendiri.
3. Menambahkan kolom `user_id` pada tabel makanan untuk menghubungkan data dengan pemiliknya.
4. Membatasi percobaan login dan registrasi maksimal 5 permintaan per menit.
5. Memastikan password disimpan dalam bentuk hash.
6. Mengubah penyimpanan token dari SharedPreferences menjadi Flutter Secure Storage.

## 4. Catatan Keamanan

Masih ada beberapa hal yang perlu diperhatikan sebelum aplikasi digunakan secara publik:

- Alamat API saat ini masih menggunakan alamat khusus Android Emulator dan HTTP untuk pengembangan lokal.
- Server produksi harus menggunakan HTTPS.
- Konfigurasi produksi harus menggunakan `APP_ENV=production` dan `APP_DEBUG=false`.
- Pengujian keamanan lebih lanjut tetap diperlukan sebelum aplikasi dipublikasikan.

## 5. Perintah Pengujian

Pengujian backend dilakukan menggunakan perintah:

```bash
composer audit
php artisan test
php artisan route:list --path=api -v
```

Pengujian frontend dilakukan menggunakan perintah:

```bash
flutter analyze
flutter test
```

## 6. Kesimpulan

Berdasarkan pengujian yang telah dilakukan, beberapa bagian keamanan FreshTrack sudah diperbaiki, terutama pada autentikasi, pembatasan akses data pengguna, pembatasan percobaan login dan registrasi, serta penyimpanan token.

Seluruh pengujian otomatis backend dan frontend yang dijalankan berhasil. Namun, konfigurasi dan pengujian tambahan tetap diperlukan sebelum aplikasi digunakan pada server produksi.