# FreshTrack 🥬 — Architecture Overview

Dokumen ini menjelaskan struktur, komponen, dan alur teknologi yang digunakan dalam pengembangan aplikasi FreshTrack. Dokumen ini akan diperbarui sesuai perkembangan project.

## 1. Project Structure

Struktur project FreshTrack dipisahkan menjadi frontend mobile dan backend API.

```text
[Project Root]/
├── backend/                    # Backend Laravel dan REST API
│   ├── app/                    # Logic utama aplikasi Laravel
│   ├── database/               # Migration dan seeder database
│   ├── routes/                 # Route dan endpoint API
│   ├── config/                 # Konfigurasi Laravel
│   └── tests/                  # Pengujian backend
│
├── frontend/                   # Aplikasi mobile Flutter
│   ├── lib/                    # Source code utama Flutter
│   │   ├── screens/            # Halaman aplikasi
│   │   ├── widgets/            # Komponen UI yang dapat digunakan kembali
│   │   ├── models/             # Model data
│   │   ├── services/           # Komunikasi dengan REST API
│   │   └── ...
│   ├── assets/                 # Gambar dan asset aplikasi
│   └── test/                   # Pengujian Flutter
│
├── README.md                   # Informasi umum project
├── user-flow.md                # Dokumentasi user flow
└── architecture.md             # Dokumentasi arsitektur aplikasi
```

> Struktur folder dapat berkembang sesuai kebutuhan selama proses pengembangan.

---

## 2. High-Level System Diagram

FreshTrack menggunakan arsitektur **client-server**. Aplikasi mobile Flutter bertindak sebagai frontend, sedangkan Laravel bertindak sebagai backend yang menyediakan REST API dan mengakses database MySQL.

```text
[User]
   ↕
[Flutter Mobile App]
   ↕
[REST API]
   ↕
[Laravel Backend]
   ↕
[MySQL Database]
```

Alur komunikasi utama:

```text
User
  ↓
Flutter Mobile App
  ↓
REST API
  ↓
Laravel Backend
  ↓
MySQL Database
  ↓
Laravel Backend
  ↓
REST API
  ↓
Flutter Mobile App
  ↓
User
```

---

## 3. Core Components

### 3.1 Frontend

**Name:** FreshTrack Mobile App

**Description:**
Aplikasi mobile yang digunakan untuk mengelola dan memantau makanan yang disimpan oleh pengguna. Pengguna dapat melakukan Register, Login, menambahkan makanan, melihat detail, mengubah data, menghapus makanan, serta melihat status dan prioritas makanan.

**Technologies:**

* Flutter
* Dart

**Target Platform:**

* Android

---

### 3.2 Backend

**Name:** FreshTrack Backend API

**Description:**
Backend menangani autentikasi pengguna, pengelolaan data makanan, validasi input, logika status makanan, sistem prioritas, dan komunikasi antara aplikasi Flutter dengan database.

**Technologies:**

* Laravel
* PHP
* REST API

---

### 3.3 Database

**Name:** FreshTrack Database

**Description:**
Database digunakan untuk menyimpan data pengguna dan data makanan yang dimiliki oleh setiap pengguna.

**Technology:**

* MySQL

---

## 4. Data Stores

### 4.1 User Data

**Name:** Users

**Type:** MySQL

**Purpose:**
Menyimpan informasi akun pengguna untuk proses autentikasi dan identifikasi pemilik data.

**Key Table:**

* `users`

Data utama:

* `id`
* `name`
* `email`
* `password`
* `created_at`

---

### 4.2 Food Data

**Name:** Foods

**Type:** MySQL

**Purpose:**
Menyimpan data makanan yang dicatat oleh pengguna.

**Key Table:**

* `foods`

Data utama:

* `id`
* `user_id`
* `name`
* `category`
* `quantity`
* `stored_date`
* `use_by_date`
* `location`
* `created_at`

Relasi data:

```text
users
  │
  └──< foods
```

Satu pengguna dapat memiliki banyak data makanan.

---

## 5. External Integrations / APIs

Pada versi awal FreshTrack, tidak terdapat integrasi dengan layanan pihak ketiga.

Aplikasi Flutter hanya berkomunikasi dengan backend FreshTrack melalui REST API.

```text
Flutter
   ↕
FreshTrack REST API
   ↕
Laravel
   ↕
MySQL
```

Fitur berikut tidak termasuk dalam scope aplikasi:

* AI
* Deteksi makanan menggunakan kamera
* IoT atau sensor suhu
* Marketplace
* Pembayaran
* GPS
* Chat antar pengguna

---

## 6. Deployment & Infrastructure

### Development Environment

Project dikembangkan menggunakan Windows.

**Frontend:**

* Flutter
* Dart
* Visual Studio Code

**Backend:**

* Laravel
* PHP

**Database:**

* MySQL
* XAMPP
* phpMyAdmin

XAMPP digunakan sebagai environment lokal untuk menjalankan MySQL dan membantu pengelolaan database melalui phpMyAdmin.

### Deployment

Pada tahap pengembangan, frontend, backend, dan database dijalankan secara lokal untuk proses coding dan testing.

Tahap deployment akan dilakukan setelah fitur utama dan pengujian aplikasi selesai.

---

## 7. Security Considerations

FreshTrack menerapkan autentikasi dan pembatasan akses data berdasarkan akun pengguna.

### Authentication

Digunakan untuk:

* Register
* Login
* Logout

### Authorization

Setiap data makanan memiliki `user_id` yang menunjukkan pemilik data.

Contoh:

```text
User A
  └── Food A1
  └── Food A2

User B
  └── Food B1
  └── Food B2
```

Pengguna hanya dapat mengakses dan mengelola makanan yang dimilikinya.

### Password Protection

Password pengguna tidak disimpan dalam bentuk teks biasa. Password akan disimpan menggunakan mekanisme hashing pada backend Laravel.

---

## 8. Development & Testing Environment

### Local Setup

Pengembangan dilakukan menggunakan:

* Windows
* Visual Studio Code
* Flutter
* Dart
* Laravel
* PHP
* XAMPP
* MySQL
* phpMyAdmin

### Testing

Pengujian dilakukan terhadap fitur utama aplikasi:

* Register dan Login
* CRUD makanan
* Validasi form
* Status makanan
* Sistem prioritas
* Navigasi aplikasi
* Komunikasi Flutter dengan REST API
* Penyimpanan data pada MySQL

---

## 9. Application Logic

FreshTrack menentukan status makanan berdasarkan `use_by_date`.

```text
Tanggal penggunaan masih jauh
        ↓
   🟢 Masih Segar

Tanggal penggunaan sudah dekat
        ↓
  🟡 Segera Digunakan

Tanggal penggunaan sudah lewat
        ↓
  🔴 Melewati Batas
```

Status tidak disimpan sebagai field terpisah di database. Status dihitung berdasarkan tanggal penggunaan yang dimasukkan pengguna.

Sistem prioritas juga menggunakan `use_by_date` untuk mengurutkan makanan berdasarkan tanggal penggunaan terdekat.

> Status hanya merupakan indikator berdasarkan tanggal yang dimasukkan pengguna dan bukan penilaian keamanan makanan.

---

## 10. Future Considerations / Roadmap

Pengembangan berikutnya dapat mencakup:

* Penyempurnaan UI dan UX.
* Validasi form yang lebih lengkap.
* Error handling dan loading state.
* Pengujian pada beberapa ukuran layar Android.
* Notifikasi pengingat makanan.
* Deployment backend ke server.
* Pembuatan APK release untuk Android.

Fitur yang berada di luar scope awal tidak menjadi bagian dari versi utama FreshTrack.

---

## 11. Project Identification

**Project Name:** FreshTrack 🥬

**Project Type:** Mobile Application

**Frontend:** Flutter (Dart)

**Backend:** Laravel (PHP)

**Database:** MySQL

**API:** REST API

**Target Platform:** Android

**Development Platform:** Windows

**Repository:** GitHub

**Date of Last Update:** 2026-09-24

---

## 12. Glossary

| Term            | Definition                                                                                    |
| --------------- | --------------------------------------------------------------------------------------------- |
| **CRUD**        | Create, Read, Update, Delete                                                                  |
| **API**         | Application Programming Interface                                                             |
| **REST API**    | Antarmuka komunikasi antara frontend dan backend menggunakan pendekatan REST                  |
| **Frontend**    | Bagian aplikasi yang berinteraksi langsung dengan pengguna                                    |
| **Backend**     | Bagian sistem yang menangani logic aplikasi, API, dan akses database                          |
| **MySQL**       | Relational Database Management System untuk menyimpan data aplikasi                           |
| **Flutter**     | Framework untuk membangun aplikasi mobile                                                     |
| **Laravel**     | Framework PHP yang digunakan untuk membangun backend                                          |
| **use_by_date** | Tanggal batas penggunaan makanan                                                              |
| **user_id**     | ID yang menghubungkan data makanan dengan pengguna                                            |
| **XAMPP**       | Local development environment yang digunakan untuk menjalankan MySQL dan layanan server lokal |
