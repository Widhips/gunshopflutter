-- ==============================================================================
-- GUN SHOP WAREHOUSE MANAGEMENT SYSTEM - 30 SAMPLE INVENTORY SEED DATA
-- Jalankan query ini di Supabase SQL Editor
-- ==============================================================================

-- 1. Pastikan Kategori Sudah Ada
INSERT INTO public.categories (name, description) VALUES
('Handguns / Pistols', 'Semi-automatic pistols and revolvers'),
('Rifles', 'Assault rifles, bolt-action, and marksman rifles'),
('Shotguns', 'Pump-action and semi-automatic shotguns'),
('Ammunition', 'Various calibers (9mm, 5.56x45mm, 7.62x51mm, 12 Gauge)'),
('Accessories & Optics', 'Scopes, suppressors, holsters, magazines, and cleaning kits')
ON CONFLICT (name) DO NOTHING;

-- 2. Insert 30 Data Inventaris
INSERT INTO public.inventory (item_code, name, category_id, description, stock, location, qr_code)
VALUES
-- ==================== KATEGORI 1: HANDGUNS / PISTOLS (7 Item) ====================
(
    'HG-001',
    'Glock 19 Gen 5 9mm',
    (SELECT id FROM public.categories WHERE name = 'Handguns / Pistols'),
    'Pistol semi-otomatis kaliber 9x19mm Parabellum, kapasitas 15 peluru. Standard law enforcement.',
    15,
    'Rak A-01',
    'HG-001'
),
(
    'HG-002',
    'Glock 17 Gen 5 9mm',
    (SELECT id FROM public.categories WHERE name = 'Handguns / Pistols'),
    'Pistol full-size kaliber 9x19mm dengan kapasitas magasin 17 peluru, barrel 4.49 inci.',
    12,
    'Rak A-02',
    'HG-002'
),
(
    'HG-003',
    'SIG Sauer P320 M17',
    (SELECT id FROM public.categories WHERE name = 'Handguns / Pistols'),
    'Pistol modular kaliber 9mm standar militer US Army dengan pelapis Coyote Tan.',
    8,
    'Rak A-03',
    'HG-003'
),
(
    'HG-004',
    'SIG Sauer P365 Micro-Compact',
    (SELECT id FROM public.categories WHERE name = 'Handguns / Pistols'),
    'Pistol conceal carry kaliber 9mm berukuran ultra-kompak dengan kapasitas 10-12 peluru.',
    20,
    'Rak A-04',
    'HG-004'
),
(
    'HG-005',
    'Colt 1911 Classic .45 ACP',
    (SELECT id FROM public.categories WHERE name = 'Handguns / Pistols'),
    'Pistol legendaris single-action kaliber .45 ACP frame baja solid, kapasitas 7 peluru.',
    6,
    'Rak A-05',
    'HG-005'
),
(
    'HG-006',
    'Beretta 92FS 9mm',
    (SELECT id FROM public.categories WHERE name = 'Handguns / Pistols'),
    'Pistol semi-otomatis double-action 9mm desain open-slide legendaris buatan Italia.',
    10,
    'Rak A-06',
    'HG-006'
),
(
    'HG-007',
    'Smith & Wesson Model 686 .357 Mag',
    (SELECT id FROM public.categories WHERE name = 'Handguns / Pistols'),
    'Revolver stainless steel 6-shot kaliber .357 Magnum / .38 Special barrel 4 inci.',
    5,
    'Rak A-07',
    'HG-007'
),

-- ==================== KATEGORI 2: RIFLES (6 Item) ====================
(
    'RF-001',
    'Colt M4A1 Carbine 5.56mm',
    (SELECT id FROM public.categories WHERE name = 'Rifles'),
    'Karabin militer semi-otomatis kaliber 5.56x45mm NATO dengan barrel chrome-moly 14.5 inci.',
    14,
    'Rak B-01',
    'RF-001'
),
(
    'RF-002',
    'FN SCAR 17S .308 Win',
    (SELECT id FROM public.categories WHERE name = 'Rifles'),
    'Senapan tempur kaliber 7.62x51mm NATO / .308 Winchester dengan monolithic aluminum receiver.',
    4,
    'Rak B-02',
    'RF-002'
),
(
    'RF-003',
    'Ruger 10/22 Carbine .22 LR',
    (SELECT id FROM public.categories WHERE name = 'Rifles'),
    'Senapan semi-otomatis kaliber rimfire .22 LR populer untuk latihan dasar dan plinking.',
    25,
    'Rak B-03',
    'RF-003'
),
(
    'RF-004',
    'Remington 700 SPS Tactical .308',
    (SELECT id FROM public.categories WHERE name = 'Rifles'),
    'Senapan bolt-action kaliber .308 Win dengan laras tebal 20 inci untuk akurasi jarak jauh.',
    7,
    'Rak B-04',
    'RF-004'
),
(
    'RF-005',
    'Heckler & Koch MR556A1 5.56mm',
    (SELECT id FROM public.categories WHERE name = 'Rifles'),
    'Senapan platform HK416 kaliber 5.56mm sistem short-stroke gas piston minim residu.',
    5,
    'Rak B-05',
    'RF-005'
),
(
    'RF-006',
    'Tikka T3x TAC A1 6.5 Creedmoor',
    (SELECT id FROM public.categories WHERE name = 'Rifles'),
    'Senapan runduk presisi tinggi modular chassis kaliber 6.5mm Creedmoor jangkauan 1000m+.',
    3,
    'Rak B-06',
    'RF-006'
),

-- ==================== KATEGORI 3: SHOTGUNS (5 Item) ====================
(
    'SG-001',
    'Remington 870 Tactical 12GA',
    (SELECT id FROM public.categories WHERE name = 'Shotguns'),
    'Shotgun pump-action legendaris kaliber 12 Gauge dengan kapasitas 6+1 shell dan ghost ring sight.',
    18,
    'Rak C-01',
    'SG-001'
),
(
    'SG-002',
    'Mossberg 590A1 Mil-Spec 12GA',
    (SELECT id FROM public.categories WHERE name = 'Shotguns'),
    'Shotgun standar militer US Navy kaliber 12GA barrel baja tebal kapasitas 8+1 shell.',
    11,
    'Rak C-02',
    'SG-002'
),
(
    'SG-003',
    'Benelli M4 Tactical Shotgun',
    (SELECT id FROM public.categories WHERE name = 'Shotguns'),
    'Shotgun semi-otomatis sistem dual gas piston ARGO kaliber 12GA standar Korps Marinir.',
    6,
    'Rak C-03',
    'SG-003'
),
(
    'SG-004',
    'Beretta 1301 Tactical Gen 2',
    (SELECT id FROM public.categories WHERE name = 'Shotguns'),
    'Shotgun taktis gas-operated semi-otomatis siklus super cepat kaliber 12GA kapasitas 7+1.',
    9,
    'Rak C-04',
    'SG-004'
),
(
    'SG-005',
    'Kel-Tec KSG Bullpup 12GA',
    (SELECT id FROM public.categories WHERE name = 'Shotguns'),
    'Shotgun desain bullpup kompak 12-gauge dengan 2 tabung magasin kapasitas total 14+1 shell.',
    8,
    'Rak C-05',
    'SG-005'
),

-- ==================== KATEGORI 4: AMMUNITION (6 Item) ====================
(
    'AM-001',
    'Magtech 9mm Luger 115gr FMJ (Box 50)',
    (SELECT id FROM public.categories WHERE name = 'Ammunition'),
    'Amunisi latihan sasaran kaliber 9x19mm Parabellum Full Metal Jacket, 1 box isi 50 butir.',
    250,
    'Gudang Peluru A-1',
    'AM-001'
),
(
    'AM-002',
    'Federal HST 9mm +P 124gr JHP (Box 20)',
    (SELECT id FROM public.categories WHERE name = 'Ammunition'),
    'Amunisi pertahanan taktis kaliber 9mm Jacketed Hollow Point daya hancur optimal, box isi 20.',
    120,
    'Gudang Peluru A-2',
    'AM-002'
),
(
    'AM-003',
    'PMC X-TAC 5.56x45mm NATO 62gr (Box 20)',
    (SELECT id FROM public.categories WHERE name = 'Ammunition'),
    'Amunisi karabin penetrator standar M855 Green Tip kaliber 5.56 NATO, 1 box isi 20 butir.',
    180,
    'Gudang Peluru B-1',
    'AM-003'
),
(
    'AM-004',
    'Winchester .308 Win 147gr FMJ (Box 20)',
    (SELECT id FROM public.categories WHERE name = 'Ammunition'),
    'Amunisi senapan laras panjang kaliber .308 Winchester / 7.62 NATO target FMJ, box isi 20.',
    90,
    'Gudang Peluru B-2',
    'AM-004'
),
(
    'AM-005',
    'Federal Premium 12GA 00 Buckshot (Box 5)',
    (SELECT id FROM public.categories WHERE name = 'Ammunition'),
    'Amunisi shotgun kaliber 12-gauge 9-pellet 00-buckshot tactical payload, box isi 5 shell.',
    150,
    'Gudang Peluru C-1',
    'AM-005'
),
(
    'AM-006',
    'CCI Standard Velocity .22 LR (Box 50)',
    (SELECT id FROM public.categories WHERE name = 'Ammunition'),
    'Amunisi target rimfire .22 Long Rifle 40gr lead round nose kecepatan subsonik, box isi 50.',
    300,
    'Gudang Peluru A-3',
    'AM-006'
),

-- ==================== KATEGORI 5: ACCESSORIES & OPTICS (6 Item) ====================
(
    'AC-001',
    'EOTech EXPS3-0 Holographic Sight',
    (SELECT id FROM public.categories WHERE name = 'Accessories & Optics'),
    'Optik bidik holografik dengan reticle 68 MOA circle & 1 MOA dot, kompatibel Night Vision.',
    10,
    'Rak D-01',
    'AC-001'
),
(
    'AC-002',
    'Aimpoint Micro T-2 Red Dot Sight',
    (SELECT id FROM public.categories WHERE name = 'Accessories & Optics'),
    'Red dot sight mil-spec ultra kompak 2 MOA dengan ketahanan baterai hingga 50.000 jam nonstop.',
    8,
    'Rak D-02',
    'AC-002'
),
(
    'AC-003',
    'Vortex Strike Eagle 1-8x24 FFP LPVO',
    (SELECT id FROM public.categories WHERE name = 'Accessories & Optics'),
    'Teropong bidik taktis jarak dekat hingga menengah dengan reticle EBR-8 First Focal Plane.',
    7,
    'Rak D-03',
    'AC-003'
),
(
    'AC-004',
    'SureFire X300 Ultra WeaponLight',
    (SELECT id FROM public.categories WHERE name = 'Accessories & Optics'),
    'Lampu senter senjata taktis 1000 lumen untuk handguns dan picatinny rail senapan.',
    16,
    'Rak D-04',
    'AC-004'
),
(
    'AC-005',
    'Magpul PMAG 30 AR/M4 GEN M3 5.56',
    (SELECT id FROM public.categories WHERE name = 'Accessories & Optics'),
    'Magasin polimer kapasitas 30 peluru kaliber 5.56x45mm NATO dengan jendela indikator transparan.',
    75,
    'Rak D-05',
    'AC-005'
),
(
    'AC-006',
    'Safariland 6360 ALS/SLS Level III Duty Holster',
    (SELECT id FROM public.categories WHERE name = 'Accessories & Optics'),
    'Sarung pistol duty retensi Level III untuk seri Glock 19/17 dengan weapon light.',
    12,
    'Rak D-06',
    'AC-006'
)
ON CONFLICT (item_code) DO UPDATE SET
    name = EXCLUDED.name,
    category_id = EXCLUDED.category_id,
    description = EXCLUDED.description,
    stock = EXCLUDED.stock,
    location = EXCLUDED.location,
    qr_code = EXCLUDED.qr_code,
    updated_at = NOW();
