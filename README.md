# FreshTrack 🥬

## 1. Deskripsi Masalah

Makanan yang disimpan di kulkas sering terlupakan karena pengguna tidak selalu mengingat kapan makanan tersebut disimpan atau kapan sebaiknya digunakan. Hal ini dapat menyebabkan makanan melewati batas penggunaan dan akhirnya terbuang.

FreshTrack membantu pengguna mencatat dan memantau makanan yang disimpan di kulkas, termasuk nama makanan, kategori, jumlah, tanggal disimpan, dan batas penggunaan. Sistem kemudian memberikan status dan menentukan makanan yang perlu digunakan terlebih dahulu.

## 2. Profil Target Pengguna

Pengguna aplikasi ini adalah individu yang menyimpan makanan di kulkas, dengan target utama:

* **Mahasiswa / Anak Kos** — Mengatur makanan yang disimpan dan menghindari makanan terlupakan.
* **Meal Prep User** — Memantau makanan yang telah disiapkan.
* **Pengguna Rumah Tangga** — Mengelola stok makanan di kulkas.

## 3. Manfaat Aplikasi

* **Mengurangi Food Waste** — Membantu pengguna menggunakan makanan sebelum melewati batas penggunaan.
* **Pengelolaan Stok** — Menyediakan daftar makanan yang tersimpan dalam satu tempat.
* **Sistem Prioritas** — Menentukan makanan yang perlu digunakan terlebih dahulu.
* **Pemantauan Makanan** — Memberikan status berdasarkan tanggal penggunaan.

## 4. Daftar Fitur Inti

### 4.1 Sistem Autentikasi

Pengguna dapat melakukan **Register** dan **Login** untuk mengakses aplikasi.

### 4.2 Manajemen Makanan (CRUD)

Pengguna dapat menambahkan, melihat, mengubah, dan menghapus data makanan.

### 4.3 Sistem Status Makanan

Sistem menentukan status makanan berdasarkan tanggal penggunaan:

* 🟢 **Masih Segar**
* 🟡 **Segera Digunakan**
* 🔴 **Melewati Batas**

> Status hanya berdasarkan tanggal yang dimasukkan pengguna dan bukan merupakan penilaian keamanan makanan.

### 4.4 Sistem Prioritas

Makanan diurutkan berdasarkan batas penggunaan, sehingga makanan dengan tanggal penggunaan paling dekat menjadi prioritas.

### 4.5 Detail Makanan

Pengguna dapat melihat informasi lengkap makanan seperti:

* Nama makanan
* Kategori
* Jumlah
* Tanggal disimpan
* Batas penggunaan
* Lokasi penyimpanan

## 5. Fitur yang Tidak Dikerjakan

Berikut fitur yang berada di luar cakupan pengembangan:

* **AI & Kamera** — Tidak menentukan kondisi atau keamanan makanan menggunakan AI atau kamera.
* **IoT** — Tidak menggunakan sensor suhu atau perangkat pintar.
* **Marketplace & Pembayaran** — Tidak menyediakan jual-beli atau transaksi makanan.
* **GPS & Chat** — Tidak menyediakan pelacakan lokasi atau komunikasi antar pengguna.

## 6. Kriteria Aplikasi Dinyatakan Berhasil

Aplikasi dinyatakan berhasil apabila:

* **Autentikasi Berhasil** — Pengguna dapat melakukan Register/Login dan mengakses data miliknya.
* **CRUD Berjalan** — Pengguna dapat mengelola data makanan.
* **Status Berjalan** — Sistem memberikan status berdasarkan tanggal penggunaan.
* **Prioritas Berjalan** — Makanan dengan batas penggunaan terdekat menjadi prioritas.
* **Database Berjalan** — Data pengguna dan makanan tersimpan dengan benar.

## 7. Teknologi Pengembangan

### Backend

* **Laravel (PHP)** — Menangani API, autentikasi, CRUD, dan logika aplikasi.
* **MySQL** — Menyimpan data pengguna dan data makanan.

### Frontend

* **Flutter (Dart)** — Digunakan untuk membangun aplikasi mobile FreshTrack untuk iOS.

### Communication

* **REST API** — Menghubungkan aplikasi Flutter dengan backend Laravel.
