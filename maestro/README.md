# Maestro UI Automation Testing - Gun Shop WMS

Direktori ini berisi test flow automasi pengujian UI menggunakan **Maestro** untuk aplikasi **Gun Shop Warehouse Management System**.

## 📱 Informasi Aplikasi
- **Application ID / Package Name**: `com.gunshop.gun_shop_wms`
- **Framework**: Flutter (Android)

---

## 📂 Struktur Folder
```text
maestro/
├── flows/
│   ├── landing.yaml                     # Fitur 1: Landing & Validasi Form Login
│   ├── login_navigation.yaml            # Fitur 2: Login Sukses & Navigasi Tab Bottom Bar
│   ├── inventory_search_detail.yaml     # Fitur 3: Pencarian Inventaris & Detail Barang
│   ├── add_item_crud.yaml               # Fitur 4: Tambah Data Inventaris (Admin CRUD)
│   └── manual_search_and_logs.yaml      # Fitur 5: Pencarian Manual SKU & Riwayat Aktivitas
└── README.md
```

---

## 🧪 5 Fitur Uji Maestro

| No | File Flow | Fitur yang Diuji | Deskripsi Skenario |
|:---:|:---|:---|:---|
| 1 | `landing.yaml` | **Landing & Validasi Form** | Memverifikasi tampilan login, validasi input kosong, format email salah (tanpa `@`), dan validasi panjang password (< 6 karakter). |
| 2 | `login_navigation.yaml` | **Login & Navigasi Tab** | Login dengan akun Admin, verifikasi metrik dashboard (Total Stok, Jenis Barang, Kategori), dan navigasi ke tab Inventaris, Scan QR, dan Profil. |
| 3 | `inventory_search_detail.yaml` | **Pencarian & Detail Inventaris** | Swipe daftar inventaris, pencarian real-time barang (contoh: "Glock"), membuka halaman Detail Barang, dan melihat generator QR Code. |
| 4 | `add_item_crud.yaml` | **Tambah Barang (Admin CRUD)** | Membuka form tambah barang, validasi field wajib, mengisi nama, SKU, deskripsi, stok, dan lokasi, lalu menyimpannya ke database. |
| 5 | `manual_search_and_logs.yaml` | **Pencarian Manual & Audit Trail** | Mencari barang dengan input manual kode SKU (`HG-001`), memeriksa riwayat aktivitas/perubahan data di menu Riwayat, dan alur Logout akun. |

---

## 🚀 Cara Menjalankan Pengujian

Pastikan aplikasi sudah terinstal di perangkat Android / emulator dan Maestro CLI telah terpasang di komputer Anda.

### 1. Jalankan Satu Test Flow Spesifik
```bash
# Uji Validasi Login
maestro test maestro/flows/landing.yaml

# Uji Login dan Navigasi
maestro test maestro/flows/login_navigation.yaml

# Uji Pencarian dan Detail Barang
maestro test maestro/flows/inventory_search_detail.yaml

# Uji Tambah Data Barang
maestro test maestro/flows/add_item_crud.yaml

# Uji Pencarian Manual & Riwayat
maestro test maestro/flows/manual_search_and_logs.yaml
```

### 2. Jalankan Seluruh Test Flow Sekaligus
```bash
maestro test maestro/flows/
```

### 3. Menjalankan di Maestro Studio (Interactive Mode)
```bash
maestro studio
```
