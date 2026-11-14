# PRODUCT REQUIREMENTS DOCUMENT (PRD)

## Gun Shop Warehouse Management System

**Platform:** Mobile Application (Android)  
**Framework:** Flutter  
**Programming Language:** Dart  
**Backend & Database:** Supabase  
**Authentication:** Supabase Auth  
**Version:** 1.0  

---

# 1. PROJECT OVERVIEW

Gun Shop Warehouse Management System adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengelolaan inventaris dan stok barang pada toko gun shop.

Aplikasi ini memiliki sistem autentikasi menggunakan email dan password yang telah didaftarkan sebelumnya melalui Supabase.

Fitur utama aplikasi meliputi:
- Login menggunakan email dan password.
- Manajemen data inventaris.
- Scan QR Code untuk mencari informasi barang.
- Generate QR Code untuk setiap barang.
- Input data barang secara manual.
- Pembagian hak akses Admin dan User.
- Pencatatan aktivitas perubahan data.

---

# 2. PROJECT OBJECTIVES

1. Mempermudah pengelolaan data inventaris gudang.
2. Mempercepat pencarian data barang menggunakan QR Code.
3. Mengurangi kesalahan pencatatan stok secara manual.
4. Memisahkan hak akses berdasarkan peran pengguna.
5. Menyimpan seluruh data secara terpusat menggunakan Supabase.
6. Menyediakan riwayat aktivitas untuk memantau perubahan data.

---

# 3. USER ROLES

## 3.1 Admin
Akses penuh terhadap inventaris:
- Login dan logout.
- Melihat seluruh data inventaris.
- Menambahkan barang.
- Mengedit informasi barang.
- Menghapus data barang.
- Mengatur jumlah stok.
- Generate QR Code.
- Scan QR Code.
- Melihat riwayat aktivitas.
- Melihat daftar pengguna.

## 3.2 User
Akses operasional gudang:
- Login dan logout.
- Melihat daftar inventaris.
- Melihat detail barang.
- Scan QR Code.
- Melihat informasi barang melalui QR Code.
- Input manual untuk pencarian barang.

*Catatan: User tidak diperbolehkan menambah, mengubah, atau menghapus data inventaris.*

---

# 4. MAIN FEATURES & SPECIFICATIONS

- **Authentication:** Email & Password via Supabase Auth, role-based redirection from `profiles.role`.
- **Dashboard:** Ringkasan statistik (total jenis barang, total stok, jumlah kategori, barang terbaru, aksi cepat).
- **Inventory Management:** CRUD barang (khusus Admin untuk create/update/delete).
- **QR Code Scanner:** Menggunakan kamera untuk membaca UUID barang dan fetch data realtime dari Supabase.
- **QR Code Generator:** Generate QR Code berbasis UUID unik barang, dapat disimpan/dibagikan/dicetak.
- **Manual Input Search:** Cari barang berdasarkan ID/kode SKU secara manual jika scanner terkendala.
- **Activity Log:** Audit trail otomatis mencatat user, aksi (CREATE, UPDATE, DELETE, STOCK_CHANGE), data lama & baru (JSONB).

---

# 5. DATABASE DESIGN (SUPABASE POSTGRESQL)

### 5.1 `profiles`
- `id` (UUID, PK, references `auth.users(id)` ON DELETE CASCADE)
- `full_name` (TEXT)
- `email` (TEXT)
- `role` (TEXT: 'admin' | 'user', default 'user')
- `created_at` (TIMESTAMPTZ, default now())

### 5.2 `categories`
- `id` (UUID, PK, default gen_random_uuid())
- `name` (TEXT, NOT NULL)
- `description` (TEXT)
- `created_at` (TIMESTAMPTZ, default now())

### 5.3 `inventory`
- `id` (UUID, PK, default gen_random_uuid())
- `item_code` (TEXT, UNIQUE, NOT NULL)
- `name` (TEXT, NOT NULL)
- `category_id` (UUID, references `categories(id)`)
- `description` (TEXT)
- `stock` (INTEGER, NOT NULL DEFAULT 0)
- `location` (TEXT)
- `qr_code` (TEXT)
- `created_at` (TIMESTAMPTZ, default now())
- `updated_at` (TIMESTAMPTZ, default now())

### 5.4 `activity_logs`
- `id` (UUID, PK, default gen_random_uuid())
- `user_id` (UUID, references `profiles(id)`)
- `item_id` (UUID, nullable)
- `action` (TEXT)
- `old_data` (JSONB)
- `new_data` (JSONB)
- `created_at` (TIMESTAMPTZ, default now())

---

# 6. GIT COMMIT CONVENTION

Format: `<type>: <description>`  
Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

Commit per logical change / per stage.
