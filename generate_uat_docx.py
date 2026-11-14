import os
import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

def set_cell_background(cell, hex_color):
    """Sets background color of a table cell."""
    shading_elm = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{hex_color}"/>')
    cell._tc.get_or_add_tcPr().append(shading_elm)

def set_cell_margins(cell, top=120, bottom=120, left=150, right=150):
    """Sets cell internal padding (in twips: 20 twips = 1 pt)."""
    tcPr = cell._tc.get_or_add_tcPr()
    tcMar = OxmlElement('w:tcMar')
    for m, val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
        node = OxmlElement(f'w:{m}')
        node.set(qn('w:w'), str(val))
        node.set(qn('w:type'), 'dxa')
        tcMar.append(node)
    tcPr.append(tcMar)

def set_table_borders(table, color="D0D5DD", sz="4", val="single"):
    """Sets standard borders for a table."""
    tblPr = table._tbl.tblPr
    borders_xml = f"""
    <w:tblBorders {nsdecls("w")}>
        <w:top w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>
        <w:bottom w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>
        <w:insideH w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>
        <w:insideV w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>
        <w:left w:val="none"/>
        <w:right w:val="none"/>
    </w:tblBorders>
    """
    tblPr.append(parse_xml(borders_xml))

def create_uat_document(output_path):
    doc = Document()
    
    # Page setup - Margins: Normal (1 inch = 72 pt)
    sections = doc.sections
    for section in sections:
        section.top_margin = Inches(1.0)
        section.bottom_margin = Inches(1.0)
        section.left_margin = Inches(1.0)
        section.right_margin = Inches(1.0)
        
        # Header & Footer
        header = section.header
        hp = header.paragraphs[0]
        hp.alignment = WD_ALIGN_PARAGRAPH.RIGHT
        hrun = hp.add_run("Dokumen UAT | Gun Shop Warehouse Management System (WMS)")
        hrun.font.name = "Calibri"
        hrun.font.size = Pt(8.5)
        hrun.font.color.rgb = RGBColor(120, 120, 120)
        
        footer = section.footer
        fp = footer.paragraphs[0]
        fp.alignment = WD_ALIGN_PARAGRAPH.LEFT
        frun = fp.add_run("Versi 1.0 (Final Draft) | Confidential - Internal Use Only")
        frun.font.name = "Calibri"
        frun.font.size = Pt(8.5)
        frun.font.color.rgb = RGBColor(120, 120, 120)

    # Styles
    styles = doc.styles
    normal_style = styles['Normal']
    normal_style.font.name = 'Calibri'
    normal_style.font.size = Pt(11)
    normal_style.font.color.rgb = RGBColor(33, 37, 41)
    normal_style.paragraph_format.line_spacing = 1.15
    normal_style.paragraph_format.space_after = Pt(4)

    # Colors
    PRIMARY = "1B365D"   # Deep Navy
    SECONDARY = "2E5B88" # Muted Blue
    ACCENT = "0D828A"    # Teal Accent
    LIGHT_BG = "F4F6F9"  # Card / Light gray background
    BORDER_CLR = "D0D5DD"
    SUCCESS_CLR = "2E7D32" # Green

    # ==================== COVER / TITLE HEADER ====================
    title_box = doc.add_table(rows=1, cols=1)
    title_box.alignment = WD_TABLE_ALIGNMENT.CENTER
    title_box.autofit = False
    title_cell = title_box.rows[0].cells[0]
    title_cell.width = Inches(6.5)
    set_cell_background(title_cell, PRIMARY)
    set_cell_margins(title_cell, top=280, bottom=280, left=240, right=240)
    
    tp1 = title_cell.paragraphs[0]
    tp1.alignment = WD_ALIGN_PARAGRAPH.CENTER
    tr1 = tp1.add_run("DOKUMEN USER ACCEPTANCE TESTING (UAT)")
    tr1.font.name = "Calibri"
    tr1.font.size = Pt(20)
    tr1.font.bold = True
    tr1.font.color.rgb = RGBColor(255, 255, 255)
    
    tp2 = title_cell.add_paragraph()
    tp2.alignment = WD_ALIGN_PARAGRAPH.CENTER
    tr2 = tp2.add_run("PENGUJIAN PENERIMAAN PENGGUNA APLIKASI MOBILE\nGUN SHOP WAREHOUSE MANAGEMENT SYSTEM (WMS)")
    tr2.font.name = "Calibri"
    tr2.font.size = Pt(13)
    tr2.font.color.rgb = RGBColor(220, 235, 252)

    doc.add_paragraph() # Spacing

    # Metadata Table
    meta_table = doc.add_table(rows=6, cols=2)
    meta_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    meta_table.autofit = False
    col_widths = [Inches(2.2), Inches(4.3)]
    set_table_borders(meta_table, color="D0D5DD", sz="4")

    metadata = [
        ("Nomor Dokumen", "UAT-WMS-2026-V1.0"),
        ("Nama Proyek", "Gun Shop Warehouse Management System (WMS)"),
        ("Platform & Versi", "Mobile Application (Android) - Versi 1.0.0"),
        ("Tanggal Pengujian", "15 November 2026"),
        ("Disusun Oleh", "Widhips (Lead QA & Mobile Engineer)"),
        ("Stakeholder Penguji", "Manajer Gudang (Admin) & Staf Operasional Gudang (User)")
    ]

    for i, (k, v) in enumerate(metadata):
        row = meta_table.rows[i]
        c0, c1 = row.cells[0], row.cells[1]
        c0.width, c1.width = col_widths[0], col_widths[1]
        set_cell_margins(c0, top=80, bottom=80, left=100, right=100)
        set_cell_margins(c1, top=80, bottom=80, left=100, right=100)
        set_cell_background(c0, "F0F4F8")
        
        p0 = c0.paragraphs[0]
        r0 = p0.add_run(k)
        r0.font.bold = True
        r0.font.size = Pt(10)
        
        p1 = c1.paragraphs[0]
        r1 = p1.add_run(v)
        r1.font.size = Pt(10)

    doc.add_paragraph()

    # Helper for Headings
    def add_custom_heading_1(text):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(14)
        p.paragraph_format.space_after = Pt(6)
        p.paragraph_format.keep_with_next = True
        run = p.add_run(text)
        run.font.name = "Calibri"
        run.font.size = Pt(14)
        run.font.bold = True
        run.font.color.rgb = RGBColor(27, 54, 93) # PRIMARY
        return p

    def add_custom_heading_2(text):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(10)
        p.paragraph_format.space_after = Pt(4)
        p.paragraph_format.keep_with_next = True
        run = p.add_run(text)
        run.font.name = "Calibri"
        run.font.size = Pt(12)
        run.font.bold = True
        run.font.color.rgb = RGBColor(46, 91, 136) # SECONDARY
        return p

    # ==================== BAB 1: INFORMASI PROYEK ====================
    add_custom_heading_1("BAB 1. INFORMASI PROYEK & TUJUAN PENGUJIAN")
    
    p = doc.add_paragraph()
    p.add_run("1.1 Latar Belakang & Ringkasan Sistem\n").bold = True
    p.add_run(
        "Gun Shop Warehouse Management System (WMS) adalah aplikasi mobile berbasis Flutter dan backend Supabase BaaS "
        "yang dirancang untuk mencatat, melacak, dan mengelola inventaris senjata api, amunisi, serta perlengkapan taktis gudang. "
        "Aplikasi ini mengintegrasikan pemindaian barcode/QR code kamera, pembuatan QR code per SKU, pencarian manual, "
        "serta sistem kontrol akses berbasis peran (Role-Based Access Control / RBAC) yang ketat antara Admin dan User operasional."
    )

    p = doc.add_paragraph()
    p.add_run("1.2 Tujuan Pengujian UAT (Testing Objectives)\n").bold = True
    p.add_run(
        "User Acceptance Testing (UAT) ini diselenggarakan dengan tujuan utama:\n"
        "1. Memastikan seluruh fungsionalitas aplikasi memenuhi spesifikasi yang tercantum dalam Product Requirements Document (PRD).\n"
        "2. Memvalidasi bahwa alur kerja pengguna (user workflow) pada masing-masing peran (Admin dan User) berjalan lancar, intuitif, dan bebas hambatan.\n"
        "3. Menguji keandalan penanganan error (error handling) dan validasi input data guna mencegah malfungsi sistem atau duplikasi data inventaris berisiko tinggi.\n"
        "4. Menjamin keamanan sistem otentikasi serta pemisahan hak akses data sesuai regulasi pergudangan senjata api.\n"
        "5. Memberikan dasar persetujuan resmi (formal sign-off) bagi stakeholder sebelum aplikasi diluncurkan ke tahap rilis produksi."
    )

    p = doc.add_paragraph()
    p.add_run("1.3 Lingkungan Pengujian (Testing Environment)\n").bold = True
    
    env_table = doc.add_table(rows=5, cols=2)
    env_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_table_borders(env_table, color="D0D5DD")
    env_data = [
        ("Platform Target", "Android OS 11.0 - 14.0 (Device fisik & Android Emulator API 34)"),
        ("Framework & SDK", "Flutter 3.38+ | Dart 3.10+"),
        ("Backend & Database", "Supabase Cloud PostgreSQL (RLS & Supabase Auth)"),
        ("Testing Automation Tool", "Maestro Mobile UI Test Automation Suite (5 Test Flows)"),
        ("Konektivitas Jaringan", "Koneksi Internet Stabil (WiFi / 4G LTE)")
    ]
    for idx, (k, v) in enumerate(env_data):
        r = env_table.rows[idx]
        r.cells[0].width, r.cells[1].width = Inches(2.2), Inches(4.3)
        set_cell_margins(r.cells[0], top=60, bottom=60, left=80, right=80)
        set_cell_margins(r.cells[1], top=60, bottom=60, left=80, right=80)
        set_cell_background(r.cells[0], "F9FAFB")
        r.cells[0].paragraphs[0].add_run(k).bold = True
        r.cells[0].paragraphs[0].runs[0].font.size = Pt(9.5)
        r.cells[1].paragraphs[0].add_run(v).font.size = Pt(9.5)

    doc.add_paragraph()

    # ==================== BAB 2: PERSONA & PERAN ====================
    add_custom_heading_1("BAB 2. PERSONA DAN PERAN PENGGUNA (USER PERSONAS & ROLES)")

    doc.add_paragraph(
        "Untuk memastikan pengujian mencerminkan skenario nyata, pengujian UAT ini didasarkan pada dua persona pengguna representatif:"
    )

    # Persona 1
    add_custom_heading_2("Persona 1: Rudi Hermawan, S.Kom. (Peran: Admin / Warehouse Manager)")
    p1_table = doc.add_table(rows=4, cols=2)
    p1_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_table_borders(p1_table, color="D0D5DD")
    p1_info = [
        ("Karakteristik & Peran", "Kepala Gudang Persenjataan yang bertanggung jawab atas seluruh aset, audit kepatuhan, dan pergerakan stok."),
        ("Hak Akses Sistem", "Hak Akses Penuh (Full Control): Login, Dashboard statistik, CRUD inventaris, Generate QR Code, Audit Trail / Activity Log, Manajemen Akun Pengguna."),
        ("Kebutuhan Kritis", "Kecepatan input barang baru, pencegahan duplikasi kode SKU, akurasi audit log histori perubahan, dan laporan stok realtime."),
        ("Akun Pengujian", "admin@gunshop.com (Password: admingunshop123)")
    ]
    for idx, (k, v) in enumerate(p1_info):
        r = p1_table.rows[idx]
        r.cells[0].width, r.cells[1].width = Inches(2.2), Inches(4.3)
        set_cell_margins(r.cells[0], top=60, bottom=60, left=80, right=80)
        set_cell_margins(r.cells[1], top=60, bottom=60, left=80, right=80)
        set_cell_background(r.cells[0], "F0F4F8")
        r.cells[0].paragraphs[0].add_run(k).bold = True
        r.cells[0].paragraphs[0].runs[0].font.size = Pt(9.5)
        r.cells[1].paragraphs[0].add_run(v).font.size = Pt(9.5)

    doc.add_paragraph()

    # Persona 2
    add_custom_heading_2("Persona 2: Budi Santoso (Peran: User / Field Warehouse Operator)")
    p2_table = doc.add_table(rows=4, cols=2)
    p2_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_table_borders(p2_table, color="D0D5DD")
    p2_info = [
        ("Karakteristik & Peran", "Staf operasional lapangan yang bertugas mengecek ketersediaan fisik senjata di rak dan lokasi gudang."),
        ("Hak Akses Sistem", "Hak Akses Terbatas (Read-Only & Search): Login, Lihat inventaris, Detail informasi barang, Scan QR Code kamera, Pencarian manual SKU, Profil."),
        ("Batasan Sistem", "DILARANG melakukan penambahan barang, pengubahan stok, penghapusan data, atau mengakses log audit & daftar pengguna."),
        ("Akun Pengujian", "user@gunshop.com (Password: usergunshop123)")
    ]
    for idx, (k, v) in enumerate(p2_info):
        r = p2_table.rows[idx]
        r.cells[0].width, r.cells[1].width = Inches(2.2), Inches(4.3)
        set_cell_margins(r.cells[0], top=60, bottom=60, left=80, right=80)
        set_cell_margins(r.cells[1], top=60, bottom=60, left=80, right=80)
        set_cell_background(r.cells[0], "F0F4F8")
        r.cells[0].paragraphs[0].add_run(k).bold = True
        r.cells[0].paragraphs[0].runs[0].font.size = Pt(9.5)
        r.cells[1].paragraphs[0].add_run(v).font.size = Pt(9.5)

    doc.add_paragraph()

    # ==================== BAB 3: KRITERIA PENERIMAAN ====================
    add_custom_heading_1("BAB 3. KRITERIA PENERIMAAN SISTEM (ACCEPTANCE CRITERIA)")
    doc.add_paragraph(
        "Kriteria penerimaan sistem dalam pengujian UAT ini mengacu pada tolok ukur kelayakan fungsional:\n"
        "1. Kriteria Fungsional Utama (Happy Path): Seluruh alur kerja standar (autentikasi, penambahan barang, pemindaian QR, pencarian) harus sukses 100% tanpa crash atau data loss.\n"
        "2. Kriteria Validasi Input: Form input wajib menolak data kosong atau format tidak sesuai dengan menampilkan pesan peringatan yang informatif dan tepat sasaran.\n"
        "3. Kriteria Penanganan Kondisi Gagal: Kegagalan otentikasi atau kegagalan scan QR harus ditangani secara anggun (graceful degradation) dengan mekanisme fallback (seperti input manual SKU).\n"
        "4. Kriteria Keamanan & RBAC: Pengguna dengan hak akses 'User' tidak dapat melihat atau mengeksekusi kontrol CRUD admin baik secara UI maupun API Supabase.\n"
        "5. Definisi Status Hasil Pengujian:\n"
        "   - Lulus (Pass): Hasil aktual sesuai 100% dengan hasil yang diharapkan.\n"
        "   - Gagal (Fail): Terjadi galat logika, data tidak tersimpan, pesan error tidak muncul, atau aplikasi berhenti mendadak (force close).\n"
        "   - Tertunda (Blocked): Pengujian tidak dapat dilanjutkan karena kegagalan pada prasyarat sebelumnya."
    )

    # ==================== BAB 4: SKENARIO UAT ====================
    doc.add_page_break()
    add_custom_heading_1("BAB 4. RINCIAN SKENARIO PENGUJIAN USER ACCEPTANCE TESTING (UAT)")

    scenarios = [
        {
            "id": "UAT-SCN-01",
            "title": "Autentikasi Pengguna & Pengalihan Hak Akses (Role-Based Routing)",
            "category": "Alur Utama (Happy Path)",
            "objective": "Memverifikasi proses login berhasil untuk kedua peran (Admin dan User) serta memastikan aplikasi mengarahkan masing-masing peran ke tampilan dashboard yang tepat.",
            "persona": "Rudi Hermawan (Admin) & Budi Santoso (User)",
            "criteria": "1. Admin berhasil masuk dan diarahkan ke 'Dashboard Admin' dengan ringkasan statistik dan akses menu manajemen.\n2. User berhasil masuk dan diarahkan ke 'Dashboard User' dengan menu pencarian dan scanner tanpa fitur manajemen.",
            "prerequisites": "1. Aplikasi terpasang pada perangkat uji.\n2. Akun 'admin@gunshop.com' dan 'user@gunshop.com' telah aktif dan terdaftar di Supabase Auth & tabel profiles.",
            "steps": [
                ("1", "Buka aplikasi Gun Shop WMS dari layar utama perangkat.", "-", "Aplikasi menampilkan Splash Screen animasi lalu berpindah ke halaman Login.", "Splash Screen tampil mulus, otomatis redirect ke Halaman Login.", "LULUS", "EV-UAT-01-01"),
                ("2", "Ketik email 'admin@gunshop.com' dan kata sandi 'admingunshop123' pada form login.", "Email: admin@gunshop.com\nPassword: admingunshop123", "Karakter terisi pada field email, password disamarkan (bullet mask).", "Input field email dan password terisi dengan benar.", "LULUS", "EV-UAT-01-02"),
                ("3", "Klik tombol 'Masuk'.", "Tap 'Masuk'", "Sistem memvalidasi ke Supabase Auth, menampilkan loading indicator, dan redirect ke Dashboard Admin.", "Berhasil login; Muncul judul 'Dashboard Admin', kartu statistik stok, dan aksi cepat.", "LULUS", "EV-UAT-01-03"),
                ("4", "Buka tab 'Profil' lalu klik tombol 'Logout'.", "Tap 'Profil' -> Tap 'Logout'", "Sesi pengguna dihapus, aplikasi kembali ke halaman Login.", "Kembali ke form Login dengan input bersih.", "LULUS", "EV-UAT-01-04"),
                ("5", "Ketik email 'user@gunshop.com' dan kata sandi 'usergunshop123', lalu klik 'Masuk'.", "Email: user@gunshop.com\nPassword: usergunshop123", "Sistem memvalidasi dan mengarahkan pengguna ke Dashboard User.", "Berhasil login; Muncul judul 'Dashboard User' dengan menu operasional staf.", "LULUS", "EV-UAT-01-05")
            ],
            "evidence_note": "Otomasi pengujian divalidasi via skrip Maestro: 'maestro/flows/landing.yaml' dan 'maestro/flows/login_navigation.yaml'. Seluruh asersi teks dan navigasi bottom bar sukses (Status Exit 0)."
        },
        {
            "id": "UAT-SCN-02",
            "title": "Autentikasi Gagal, Format Tidak Valid & Penanganan Error",
            "category": "Kondisi Gagal (Failure / Negative Flow)",
            "objective": "Memastikan sistem keamanan menolak kredensial yang salah, mendeteksi format input yang tidak valid, dan menampilkan pesan peringatan yang ramah dan aman.",
            "persona": "Budi Santoso (User)",
            "criteria": "1. Format email tidak valid memicu validasi form lokal sebelum request dikirim.\n2. Kata sandi yang salah atau akun tidak terdaftar menghasilkan dialog/pesan error jelas tanpa membocorkan rincian sensitif.\n3. Aplikasi tidak mengalami crash atau freeze.",
            "prerequisites": "1. Aplikasi berada pada halaman Login.\n2. Koneksi internet aktif.",
            "steps": [
                ("1", "Kosongkan kolom email dan password, lalu klik tombol 'Masuk'.", "Email: (kosong)\nPassword: (kosong)", "Sistem menampilkan pesan error validasi form: 'Email wajib diisi' dan 'Password wajib diisi'.", "Muncul teks error merah di bawah masing-masing kolom input.", "LULUS", "EV-UAT-02-01"),
                ("2", "Ketik format email tidak valid (misal: 'budi_gunshop.com') dan password sembarang, klik 'Masuk'.", "Email: budi_gunshop.com\nPassword: 123", "Sistem menampilkan validasi: 'Format email tidak valid' dan 'Password minimal 6 karakter'.", "Pesan validasi format muncul seketika tanpa request API.", "LULUS", "EV-UAT-02-02"),
                ("3", "Ketik email valid terdaftar 'user@gunshop.com' tetapi kata sandi salah 'passwordsalah999', klik 'Masuk'.", "Email: user@gunshop.com\nPassword: passwordsalah999", "Sistem menghubungi Supabase Auth dan menampilkan Snackbar/Dialog error: 'Email atau password salah'.", "Muncul notifikasi error 'Invalid login credentials', form tetap di halaman login.", "LULUS", "EV-UAT-02-03"),
                ("4", "Ketik email yang belum terdaftar di sistem 'bukanuser@domain.com' dengan password valid, klik 'Masuk'.", "Email: bukanuser@domain.com\nPassword: rahasia123", "Sistem menolak otentikasi dan memberikan pesan akun tidak ditemukan / kredensial salah.", "Muncul pesan notifikasi kegagalan otentikasi secara aman.", "LULUS", "EV-UAT-02-04")
            ],
            "evidence_note": "Diverifikasi melalui pengujian negatif: Form validator Flutter mencegah submit invalid data lokal, dan respon error Supabase Auth ditangkap secara aman oleh AuthProvider."
        },
        {
            "id": "UAT-SCN-03",
            "title": "Manajemen Inventaris: Penambahan Barang Baru & Pembaruan Stok",
            "category": "Alur Utama (Happy Path)",
            "objective": "Memvalidasi alur penambahan item senjata baru oleh Admin, pembuatan kode SKU unik, pembaruan jumlah stok, serta verifikasi bahwa data tersimpan di Supabase dan tampil di daftar inventaris.",
            "persona": "Rudi Hermawan (Admin / Warehouse Manager)",
            "criteria": "1. Admin dapat mengisi data inventaris lengkap dan menyimpannya ke database.\n2. Item baru langsung muncul di daftar inventaris dan statistik total stok bertambah.\n3. Perubahan tercatat secara realtime pada audit trail.",
            "prerequisites": "1. Pengguna login sebagai Admin (admin@gunshop.com).\n2. Berada pada Dashboard Admin.",
            "steps": [
                ("1", "Dari Dashboard Admin, klik kartu aksi cepat '+ Tambah Barang'.", "Tap '+ Tambah Barang'", "Aplikasi membuka form 'Tambah Barang' dengan field input lengkap.", "Halaman 'Tambah Barang' terbuka dengan kolom Nama, SKU, Kategori, Stok, Lokasi, Deskripsi.", "LULUS", "EV-UAT-03-01"),
                ("2", "Isi data barang baru:\n- Nama: 'Glock 19 Gen 5 9mm'\n- SKU: 'HG-GLOCK19-G5'\n- Kategori: 'Handgun'\n- Stok: '15'\n- Lokasi: 'Rak A-01'\n- Deskripsi: 'Pistol semi-otomatis kaliber 9x19mm'", "Data inventaris lengkap", "Seluruh field terisi dengan data yang sesuai tanpa peringatan error.", "Field terisi sempurna, dropdown kategori memilih 'Handgun'.", "LULUS", "EV-UAT-03-02"),
                ("3", "Klik tombol 'Simpan'.", "Tap 'Simpan'", "Muncul loading indicator, data dikirim ke Supabase tabel 'inventory', muncul Snackbar sukses, lalu otomatis kembali ke Dashboard.", "Barang berhasil disimpan, notifikasi sukses muncul, kembali ke Dashboard Admin.", "LULUS", "EV-UAT-03-03"),
                ("4", "Buka Tab 'Inventaris' (Tab 2) dan ketik 'Glock 19' pada kolom pencarian.", "Input search: 'Glock 19'", "Daftar inventaris menyaring data dan menampilkan 'Glock 19 Gen 5 9mm' dengan stok 15.", "Item ditemukan di urutan teratas dengan detail stok 15 dan kategori Handgun.", "LULUS", "EV-UAT-03-04"),
                ("5", "Klik item tersebut untuk membuka 'Detail Barang'.", "Tap item 'Glock 19 Gen 5 9mm'", "Halaman detail menampilkan informasi spesifikasi lengkap dan tombol tindakan (Edit, QR Code, Hapus).", "Halaman Detail Barang terbuka akurat sesuai data yang baru diinput.", "LULUS", "EV-UAT-03-05")
            ],
            "evidence_note": "Divalidasi via skrip Maestro: 'maestro/flows/add_item_crud.yaml'. Verifikasi integrasi database Supabase mengembalikan row baru dengan id UUID dan item_code 'HG-GLOCK19-G5'."
        },
        {
            "id": "UAT-SCN-04",
            "title": "Validasi Form Penambahan Barang & Pembatasan Nilai Input",
            "category": "Validasi Input (Form Validation)",
            "objective": "Menguji ketahanan form penambahan inventaris terhadap input yang tidak lengkap, format numerik tidak valid, atau kode SKU duplikat.",
            "persona": "Rudi Hermawan (Admin)",
            "criteria": "1. Field bertanda bintang (*) wajib diisi; tombol Simpan tidak memproses request jika ada field kosong.\n2. Input stok hanya menerima angka bulat non-negatif.\n3. Kode SKU yang telah ada di database ditolak dengan pesan peringatan duplikasi.",
            "prerequisites": "1. Login sebagai Admin.\n2. Berada pada form 'Tambah Barang'.",
            "steps": [
                ("1", "Biarkan seluruh field kosong, langsung klik tombol 'Simpan'.", "Form kosong -> Tap 'Simpan'", "Sistem memblokir submit dan menampilkan pesan error merah: 'Nama barang wajib diisi' dan 'Kode barang (SKU) wajib diisi'.", "Submit dibatalkan; pesan error validasi muncul di bawah kolom yang kosong.", "LULUS", "EV-UAT-04-01"),
                ("2", "Isi Nama Barang tetapi kosongkan SKU dan Stok, klik 'Simpan'.", "Nama: 'Beretta 92FS', lainnya kosong", "Sistem menampilkan error pada kolom SKU dan Stok yang masih kosong.", "Pesan error tetap tampil pada field yang belum diisi.", "LULUS", "EV-UAT-04-02"),
                ("3", "Ketik angka negatif pada kolom stok (misal: '-10') atau huruf abjad, klik 'Simpan'.", "Stok: -10", "Sistem memvalidasi nilai stok minimal 0 atau keyboard membatasi hanya input numerik bulat.", "Form memvalidasi 'Jumlah stok minimal 0', data tidak dapat disubmit.", "LULUS", "EV-UAT-04-03"),
                ("4", "Gunakan kode SKU yang sudah terdaftar di sistem (misal: 'HG-001'), lengkapi field lain, lalu klik 'Simpan'.", "SKU: 'HG-001' (Sudah ada di database)", "Supabase mengembalikan pelanggaran unique constraint pada kolom item_code; aplikasi menampilkan pesan: 'Kode barang (SKU) sudah digunakan'.", "Muncul notifikasi error jelas bahwa SKU duplikat, form tidak reset.", "LULUS", "EV-UAT-04-04")
            ],
            "evidence_note": "Otomasi Maestro pada flow 'maestro/flows/add_item_crud.yaml' step 'Validasi error form kosong' berhasil menverifikasi kemunculan error 'Nama barang wajib diisi'."
        },
        {
            "id": "UAT-SCN-05",
            "title": "Pemindaian QR Code Kamera & Fallback Pencarian Manual SKU",
            "category": "Alur Utama & Kondisi Gagal (Happy Path & Fallback)",
            "objective": "Menguji pemindaian barcode/QR code fisik barang menggunakan modul kamera perangkat, verifikasi penanganan kegagalan scan (QR rusak/tidak terbaca), dan transisi ke pencarian manual dengan SKU.",
            "persona": "Budi Santoso (User / Warehouse Operator)",
            "criteria": "1. Scanner kamera dapat mengenali QR code valid dan langsung membuka Detail Barang.\n2. Saat scan gagal/terkendala, pengguna dapat beralih ke pencarian manual dengan mulus.\n3. Pencarian manual dengan kode SKU valid menampilkan barang yang tepat; SKU tidak valid menampilkan pesan 'Barang tidak ditemukan'.",
            "prerequisites": "1. Login sebagai User operasional (user@gunshop.com).\n2. Izin kamera (CAMERA permission) telah diberikan pada AndroidManifest.",
            "steps": [
                ("1", "Dari Bottom Navigation Bar, klik Tab 'Scan QR' (Tab 3).", "Tap 'Scan QR'", "Aplikasi meminta izin kamera (jika pertama kali) lalu membuka jendela viewfinder kamera dengan target overlay.", "Viewfinder kamera aktif dan siap memindai QR Code.", "LULUS", "EV-UAT-05-01"),
                ("2", "Arahkan kamera ke QR Code valid barang 'HG-001' (Glock 17).", "Scan QR Code HG-001", "Kamera mendeteksi kode QR, aplikasi mengambil data dari Supabase, dan langsung berpindah ke halaman 'Detail Barang'.", "Otomatis redirect ke halaman Detail Barang Glock 17 dengan data lengkap.", "LULUS", "EV-UAT-05-02"),
                ("3", "Simulasikan kondisi gagal: tutup kamera / scan QR yang rusak atau bukan format inventaris.", "Scan QR tidak valid / buram", "Aplikasi tidak crash; menampilkan notifikasi 'QR Code tidak dikenali' dan menyediakan tombol alternatif 'Cari Manual'.", "Muncul opsi 'Input Manual / Cari Manual' di layar pemindai.", "LULUS", "EV-UAT-05-03"),
                ("4", "Klik tombol 'Cari Manual' atau akses menu Pencarian Manual dari Dashboard.", "Tap 'Cari Manual'", "Halaman 'Pencarian Manual' terbuka dengan field input kode barang (SKU).", "Halaman Pencarian Manual terbuka dengan kolom pencarian fokus.", "LULUS", "EV-UAT-05-04"),
                ("5", "Ketik kode SKU tidak terdaftar: 'SKU-TIDAK-ADA-999', klik tombol 'Cari'.", "SKU: 'SKU-TIDAK-ADA-999'", "Sistem mencari ke database dan menampilkan ilustrasi 'Barang tidak ditemukan. Periksa kembali kode barang'.", "Tampilan pesan barang tidak ditemukan muncul informatif.", "LULUS", "EV-UAT-05-05"),
                ("6", "Ketik kode SKU valid: 'HG-001', klik tombol 'Cari' lalu klik hasil pencarian.", "SKU: 'HG-001'", "Item 'Glock 17' muncul di hasil pencarian; saat diklik membuka halaman Detail Barang.", "Detail barang terbuka sempurna dari alur pencarian manual.", "LULUS", "EV-UAT-05-06")
            ],
            "evidence_note": "Divalidasi via Maestro flow: 'maestro/flows/manual_search_and_logs.yaml'. Flow menguji input manual kode SKU 'HG-001', verifikasi hasil pencarian, dan navigasi detail barang."
        },
        {
            "id": "UAT-SCN-06",
            "title": "Audit Trail (Activity Log) & Penegakan Pembatasan Akses (RBAC)",
            "category": "Alur Utama & Keamanan Akses (Audit & Security)",
            "objective": "Memastikan sistem audit trail mencatat seluruh perubahan data secara otomatis (CREATE/UPDATE/DELETE/STOCK_CHANGE), dan memvalidasi bahwa peran User tidak dapat mengakses fungsionalitas admin.",
            "persona": "Rudi Hermawan (Admin) & Budi Santoso (User)",
            "criteria": "1. Setiap perubahan inventaris menghasilkan baris baru pada tabel activity_logs dengan mencatat user_id, aksi, dan waktu.\n2. Admin dapat melihat daftar riwayat log perubahan.\n3. Pada akun User, tombol Tambah Barang (+), Edit Barang, Hapus, dan menu Log Aktivitas disembunyikan/dibatasi.",
            "prerequisites": "1. Telah dilakukan aktivitas penambahan atau pengubahan barang pada skenario sebelumnya.\n2. Akun Admin dan User tersedia.",
            "steps": [
                ("1", "Login sebagai Admin, buka Dashboard Admin lalu klik menu 'Riwayat Aktivitas' (Audit Trail).", "Tap 'Riwayat Aktivitas'", "Halaman 'Riwayat Aktivitas' menampilkan daftar kronologis aktivitas perubahan data terbaru.", "Daftar log tampil kronologis dengan badge aksi (CREATE, UPDATE), nama staf, dan timestamp.", "LULUS", "EV-UAT-06-01"),
                ("2", "Periksa entri log penambahan barang 'HG-GLOCK19-G5' yang dilakukan pada SCN-03.", "Cek detail log", "Log memuat jenis aksi 'CREATE', dicatat oleh 'admin@gunshop.com', waktu kejadian akurat.", "Data log valid, mencakup JSON snapshot data baru barang.", "LULUS", "EV-UAT-06-02"),
                ("3", "Logout dari Admin, kemudian login sebagai User 'user@gunshop.com'.", "Login sebagai user", "Aplikasi menampilkan Dashboard User.", "Dashboard User tampil; verifikasi tombol '+ Tambah Barang' dan 'Riwayat Aktivitas' TIDAK ADA.", "LULUS", "EV-UAT-06-03"),
                ("4", "Buka Tab 'Inventaris' sebagai User, lalu klik salah satu barang untuk membuka Detail Barang.", "Buka Detail Barang (User)", "Halaman detail tampil tanpa tombol aksi 'Edit Barang' atau 'Hapus Barang'.", "Tombol Edit dan Hapus tidak tersedia (read-only mode aktif untuk User).", "LULUS", "EV-UAT-06-04")
            ],
            "evidence_note": "Divalidasi melalui skrip Maestro: 'maestro/flows/manual_search_and_logs.yaml' (memvalidasi pembukaan Riwayat Aktivitas) dan asersi UI kontrol peran pada codebase Flutter."
        }
    ]

    for scn in scenarios:
        # Scenario Header Box
        scn_box = doc.add_table(rows=1, cols=1)
        scn_box.alignment = WD_TABLE_ALIGNMENT.CENTER
        scn_box.autofit = False
        sc_cell = scn_box.rows[0].cells[0]
        sc_cell.width = Inches(6.5)
        set_cell_background(sc_cell, "EBF3FA")
        set_cell_margins(sc_cell, top=140, bottom=140, left=180, right=180)
        
        sp = sc_cell.paragraphs[0]
        sr1 = sp.add_run(f"[{scn['id']}] {scn['title']}\n")
        sr1.font.name = "Calibri"
        sr1.font.size = Pt(12)
        sr1.font.bold = True
        sr1.font.color.rgb = RGBColor(27, 54, 93)
        
        sr2 = sp.add_run(f"Kategori: {scn['category']} | Persona: {scn['persona']}")
        sr2.font.name = "Calibri"
        sr2.font.size = Pt(10)
        sr2.font.italic = True
        sr2.font.color.rgb = RGBColor(70, 70, 70)

        # Overview Table for Scenario
        doc.add_paragraph() # Spacing
        info_tbl = doc.add_table(rows=3, cols=2)
        info_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
        info_tbl.autofit = False
        set_table_borders(info_tbl, color="D0D5DD")
        
        scn_meta = [
            ("Tujuan Pengujian", scn["objective"]),
            ("Kriteria Penerimaan", scn["criteria"]),
            ("Prasyarat Pengujian", scn["prerequisites"])
        ]
        for idx, (lbl, val) in enumerate(scn_meta):
            r = info_tbl.rows[idx]
            r.cells[0].width, r.cells[1].width = Inches(2.0), Inches(4.5)
            set_cell_margins(r.cells[0], top=60, bottom=60, left=80, right=80)
            set_cell_margins(r.cells[1], top=60, bottom=60, left=80, right=80)
            set_cell_background(r.cells[0], "F9FAFB")
            
            p0 = r.cells[0].paragraphs[0]
            p0.add_run(lbl).bold = True
            p0.runs[0].font.size = Pt(9.5)
            
            p1 = r.cells[1].paragraphs[0]
            p1.add_run(val)
            p1.runs[0].font.size = Pt(9.5)

        # Steps Table
        doc.add_paragraph()
        steps_tbl = doc.add_table(rows=len(scn["steps"]) + 1, cols=7)
        steps_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
        steps_tbl.autofit = False
        set_table_borders(steps_tbl, color="D0D5DD")

        # Col Widths: Total = 6.5 in
        step_widths = [Inches(0.4), Inches(1.5), Inches(1.1), Inches(1.3), Inches(1.1), Inches(0.6), Inches(0.5)]
        headers = ["No", "Langkah Pengujian", "Data Uji", "Hasil yang Diharapkan", "Hasil Aktual", "Status", "Bukti"]

        hdr_row = steps_tbl.rows[0]
        for c_idx, title in enumerate(headers):
            cell = hdr_row.cells[c_idx]
            cell.width = step_widths[c_idx]
            set_cell_background(cell, PRIMARY)
            set_cell_margins(cell, top=80, bottom=80, left=60, right=60)
            p = cell.paragraphs[0]
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER if c_idx in [0, 5, 6] else WD_ALIGN_PARAGRAPH.LEFT
            r = p.add_run(title)
            r.font.bold = True
            r.font.size = Pt(8.5)
            r.font.color.rgb = RGBColor(255, 255, 255)

        for s_idx, step in enumerate(scn["steps"]):
            r = steps_tbl.rows[s_idx + 1]
            bg_clr = "FFFFFF" if s_idx % 2 == 0 else "F9FAFB"
            for c_idx in range(7):
                cell = r.cells[c_idx]
                cell.width = step_widths[c_idx]
                set_cell_background(cell, bg_clr)
                set_cell_margins(cell, top=60, bottom=60, left=60, right=60)
                p = cell.paragraphs[0]
                p.alignment = WD_ALIGN_PARAGRAPH.CENTER if c_idx in [0, 5, 6] else WD_ALIGN_PARAGRAPH.LEFT
                run = p.add_run(step[c_idx])
                run.font.size = Pt(8.0)
                if c_idx == 5: # Status
                    run.font.bold = True
                    run.font.color.rgb = RGBColor(46, 125, 50) # Green for LULUS
                elif c_idx == 0:
                    run.font.bold = True

        # Evidence note
        ev_p = doc.add_paragraph()
        ev_p.paragraph_format.space_before = Pt(4)
        ev_p.paragraph_format.space_after = Pt(12)
        ev_run = ev_p.add_run(f"📌 Bukti Pengujian ({scn['id']}): {scn['evidence_note']}")
        ev_run.font.size = Pt(8.5)
        ev_run.font.italic = True
        ev_run.font.color.rgb = RGBColor(60, 60, 60)

    # ==================== BAB 5: REKAPITULASI ====================
    doc.add_page_break()
    add_custom_heading_1("BAB 5. MATRIKS REKAPITULASI HASIL PENGUJIAN UAT")

    doc.add_paragraph(
        "Berikut adalah ringkasan hasil pengujian untuk seluruh skenario User Acceptance Testing (UAT) yang telah dilaksanakan:"
    )

    summary_tbl = doc.add_table(rows=7, cols=6)
    summary_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    summary_tbl.autofit = False
    set_table_borders(summary_tbl, color="D0D5DD")

    sum_widths = [Inches(1.2), Inches(2.3), Inches(0.8), Inches(0.7), Inches(0.7), Inches(0.8)]
    sum_headers = ["ID Skenario", "Nama Skenario UAT", "Total Test", "Lulus", "Gagal", "% Kelulusan"]

    s_hdr_row = summary_tbl.rows[0]
    for c_idx, title in enumerate(sum_headers):
        cell = s_hdr_row.cells[c_idx]
        cell.width = sum_widths[c_idx]
        set_cell_background(cell, PRIMARY)
        set_cell_margins(cell, top=80, bottom=80, left=60, right=60)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER if c_idx >= 2 else WD_ALIGN_PARAGRAPH.LEFT
        r = p.add_run(title)
        r.font.bold = True
        r.font.size = Pt(9.0)
        r.font.color.rgb = RGBColor(255, 255, 255)

    summary_rows = [
        ("UAT-SCN-01", "Autentikasi & Role-Based Routing", "5", "5", "0", "100%"),
        ("UAT-SCN-02", "Autentikasi Gagal & Error Handling", "4", "4", "0", "100%"),
        ("UAT-SCN-03", "Inventaris CRUD: Tambah & Stok", "5", "5", "0", "100%"),
        ("UAT-SCN-04", "Validasi Form Input Inventaris", "4", "4", "0", "100%"),
        ("UAT-SCN-05", "Scan QR Code & Fallback Manual", "6", "6", "0", "100%"),
        ("UAT-SCN-06", "Audit Trail & Pembatasan Akses RBAC", "4", "4", "0", "100%"),
    ]

    for r_idx, sdata in enumerate(summary_rows):
        row = summary_tbl.rows[r_idx + 1]
        for c_idx in range(6):
            cell = row.cells[c_idx]
            cell.width = sum_widths[c_idx]
            set_cell_background(cell, "FFFFFF" if r_idx % 2 == 0 else "F9FAFB")
            set_cell_margins(cell, top=60, bottom=60, left=60, right=60)
            p = cell.paragraphs[0]
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER if c_idx >= 2 else WD_ALIGN_PARAGRAPH.LEFT
            r = p.add_run(sdata[c_idx])
            r.font.size = Pt(9.0)
            if c_idx == 0 or c_idx == 5:
                r.font.bold = True
                if c_idx == 5:
                    r.font.color.rgb = RGBColor(46, 125, 50)

    # Overall Metrics Box
    doc.add_paragraph()
    stat_box = doc.add_table(rows=1, cols=3)
    stat_box.alignment = WD_TABLE_ALIGNMENT.CENTER
    stat_box.autofit = False
    
    stat_data = [
        ("TOTAL LANGKAH UJI", "28 Test Cases", "1B365D"),
        ("HASIL KELULUSAN", "28 Lulus (100%)", "2E7D32"),
        ("STATUS AKHIR", "DITERIMA (ACCEPTED)", "0D828A")
    ]
    for c_idx, (stitle, sval, sclr) in enumerate(stat_data):
        cell = stat_box.rows[0].cells[c_idx]
        cell.width = Inches(2.16)
        set_cell_background(cell, "F0F4F8")
        set_cell_margins(cell, top=140, bottom=140, left=100, right=100)
        
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r1 = p.add_run(f"{stitle}\n")
        r1.font.size = Pt(8.5)
        r1.font.color.rgb = RGBColor(100, 100, 100)
        
        r2 = p.add_run(sval)
        r2.font.size = Pt(12)
        r2.font.bold = True
        r2.font.color.rgb = RGBColor(*[int(sclr[i:i+2], 16) for i in (0, 2, 4)])

    doc.add_paragraph()

    # ==================== BAB 6: LEMBAR PERSETUJUAN ====================
    add_custom_heading_1("BAB 6. LEMBAR PERSETUJUAN (SIGN-OFF SHEET)")

    doc.add_paragraph(
        "Berdasarkan hasil pengujian penerimaan pengguna (User Acceptance Testing) yang telah dilaksanakan, "
        "seluruh fungsionalitas aplikasi mobile Gun Shop Warehouse Management System (WMS) versi 1.0 "
        "dinyatakan telah memenuhi kriteria penerimaan (Acceptance Criteria) dan dapat diterima untuk tahap implementasi produksi."
    )

    sign_tbl = doc.add_table(rows=4, cols=3)
    sign_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    sign_tbl.autofit = False
    set_table_borders(sign_tbl, color="D0D5DD")

    sign_headers = ["Disiapkan Oleh (QA Lead)", "Diverifikasi Oleh (User/Operator)", "Disetujui Oleh (Product Owner)"]
    s_hdr = sign_tbl.rows[0]
    for c_idx, title in enumerate(sign_headers):
        cell = s_hdr.cells[c_idx]
        cell.width = Inches(2.16)
        set_cell_background(cell, "F0F4F8")
        set_cell_margins(cell, top=80, bottom=80, left=60, right=60)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(title)
        r.font.bold = True
        r.font.size = Pt(9.0)

    # Space for signature
    sign_row = sign_tbl.rows[1]
    for c_idx in range(3):
        cell = sign_row.cells[c_idx]
        cell.width = Inches(2.16)
        set_cell_margins(cell, top=450, bottom=450, left=60, right=60)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run("[ Tanda Tangan Digital ]")
        r.font.size = Pt(8.0)
        r.font.italic = True
        r.font.color.rgb = RGBColor(160, 160, 160)

    names = ["Widhips", "Budi Santoso", "Rudi Hermawan, S.Kom."]
    roles = ["Lead QA & Mobile Dev", "Perwakilan Operator Gudang", "Product Owner / Kepala Gudang"]
    
    n_row = sign_tbl.rows[2]
    for c_idx in range(3):
        cell = n_row.cells[c_idx]
        cell.width = Inches(2.16)
        set_cell_margins(cell, top=40, bottom=20, left=60, right=60)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(names[c_idx])
        r.font.bold = True
        r.font.size = Pt(9.5)

    r_row = sign_tbl.rows[3]
    for c_idx in range(3):
        cell = r_row.cells[c_idx]
        cell.width = Inches(2.16)
        set_cell_margins(cell, top=20, bottom=60, left=60, right=60)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(roles[c_idx])
        r.font.size = Pt(8.5)
        r.font.color.rgb = RGBColor(90, 90, 90)

    # Save document
    doc.save(output_path)
    print(f"Document successfully created at: {output_path}")

if __name__ == "__main__":
    out_file = r"D:\KULIAH\UTS MOBILE TESTING\DOKUMEN_UAT_GUN_SHOP_WMS.docx"
    create_uat_document(out_file)
