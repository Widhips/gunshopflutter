# Gun Shop Warehouse Management System (WMS) 🔫📦

A modern, secure Mobile Warehouse Management System (WMS) built using **Flutter**, **Supabase**, and **Maestro UI Testing** for firearms inventory tracking, QR scanning, and role-based access management.

---

## 🚀 Fitur Utama

### 👥 Role-Based Access Control (RBAC)
- **Admin**:
  - Dashboard statistik stok, nilai aset, dan kategori.
  - Manajemen Inventaris lengkap (CRUD: Tambah, Lihat, Edit, Hapus).
  - Generator QR Code otomatis untuk setiap SKU/Barang.
  - Audit Trail / Riwayat Aktivitas realtime.
  - Manajemen Akun Pengguna / Staf Gudang.
- **User / Operator Gudang**:
  - Dashboard ringkasan inventaris.
  - Pencarian dan filter inventaris.
  - Scanner QR Code berbasis kamera untuk pencarian cepat.
  - Pencarian manual dengan kode SKU.
  - Profil pengguna & logout aman.

### 🔍 QR Code & Tracking
- Scanner QR Code cepat menggunakan kamera perangkat (`mobile_scanner`).
- Generator QR Code unik per SKU (`qr_flutter`) yang dapat disimpan dan dibagikan (`share_plus`).

### ⚡ Backend Supabase (BaaS)
- Autentikasi aman berbasis email & password.
- Row Level Security (RLS) pada tabel Postgres.
- Skrip migrasi skema database (`supabase_schema.sql`).
- Skrip data awal 30 item senjata & amunisi (`supabase_seed_30_items.sql`).

### 🧪 Automated E2E Testing with Maestro
Pengujian fungsionalitas dan UI otomatis menggunakan Maestro:
- `landing.yaml`: Verifikasi splash screen dan tampilan awal.
- `login_navigation.yaml`: Autentikasi dan navigasi seluruh tab.
- `add_item_crud.yaml`: Validasi form dan penambahan barang.
- `inventory_search_detail.yaml`: Pencarian barang, detail, dan QR generator.
- `manual_search_and_logs.yaml`: Pencarian SKU manual, audit logs, dan logout.

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `^3.10.1`)
- **Backend**: [Supabase](https://supabase.com) (`supabase_flutter: ^2.8.4`)
- **State Management**: [Provider](https://pub.dev/packages/provider) (`provider: ^6.1.2`)
- **QR Code Tools**:
  - `mobile_scanner: ^6.0.7`
  - `qr_flutter: ^4.1.0`
- **Utility & UI**:
  - `flutter_dotenv: ^5.2.1`
  - `intl: ^0.20.2`
  - `fl_chart: ^1.1.1`
  - `share_plus: ^10.1.4`
- **Testing**: [Maestro](https://maestro.mobile.dev)

---

## 📂 Struktur Proyek

```text
lib/
├── config/           # Konfigurasi aplikasi & konstanta
├── models/           # Data models (Inventory, Category, User, ActivityLog)
├── providers/        # State management (AuthProvider, InventoryProvider)
├── screens/          # UI Screens (Auth, Admin, User, Shared)
│   ├── auth/         # Login & Splash Screen
│   ├── admin/        # Admin Dashboard, CRUD Barang, Logs, User List
│   ├── user/         # User Dashboard
│   └── shared/       # Inventory List, Detail, QR Scanner, QR Generator
├── services/         # Supabase & External API services
├── utils/            # Helper & Formatter
└── widgets/          # Reusable UI Components
maestro/
└── flows/            # 5 Skrip Automated E2E Testing
```

---

## ⚙️ Persiapan & Instalasi

### 1. Clone Repository
```bash
git clone https://github.com/Widhips/gunshopflutter.git
cd gunshopflutter
```

### 2. Konfigurasi Environment (`.env`)
Buat file `.env` di root direktori proyek:
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Setup Database Supabase
Jalankan skrip SQL berikut pada Supabase SQL Editor:
1. `supabase_schema.sql` (Tabel, RLS, Trigger, Index)
2. `supabase_seed_30_items.sql` (Data sample 30 senjata & amunisi)

### 5. Jalankan Aplikasi
```bash
flutter run
```

---

## 🧪 Menjalankan Automated UI Test (Maestro)

Pastikan emulator Android / perangkat fisik terhubung via ADB:
```bash
# Uji seluruh alur flow:
maestro test maestro/flows/landing.yaml
maestro test maestro/flows/login_navigation.yaml
maestro test maestro/flows/add_item_crud.yaml
maestro test maestro/flows/inventory_search_detail.yaml
maestro test maestro/flows/manual_search_and_logs.yaml
```

---

## 👤 Penulis
- GitHub: [@Widhips](https://github.com/Widhips)
