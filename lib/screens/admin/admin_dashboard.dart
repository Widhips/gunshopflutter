import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/inventory_provider.dart';
import '../auth/login_screen.dart';
import '../shared/inventory_list_screen.dart';
import '../shared/item_detail_screen.dart';
import '../shared/qr_scanner_screen.dart';
import '../shared/manual_search_screen.dart';
import '../shared/profile_screen.dart';
import 'add_item_screen.dart';
import 'activity_log_screen.dart';
import 'user_list_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final inventoryProvider = context.read<InventoryProvider>();
    await Future.wait([
      inventoryProvider.loadStats(),
      inventoryProvider.loadItems(),
      inventoryProvider.loadCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildDashboardContent(),
      const InventoryListScreen(isAdmin: true),
      const QrScannerScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventaris',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            selectedIcon: Icon(Icons.qr_code_scanner),
            label: 'Scan QR',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: const Color(0xFF1B2A4A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer<InventoryProvider>(
          builder: (context, inventory, _) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      return Text(
                        'Selamat Datang, ${auth.profile?.fullName ?? 'Admin'}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kelola inventaris gudang Anda',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Jenis Barang',
                          value: '${inventory.stats['totalItems'] ?? 0}',
                          icon: Icons.category,
                          color: const Color(0xFF1B2A4A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Total Stok',
                          value: '${inventory.stats['totalStock'] ?? 0}',
                          icon: Icons.inventory,
                          color: Colors.green[700]!,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Kategori',
                          value: '${inventory.stats['totalCategories'] ?? 0}',
                          icon: Icons.label,
                          color: Colors.orange[700]!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions
                  const Text(
                    'Aksi Cepat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.8,
                    children: [
                      _ActionCard(
                        title: 'Tambah Barang',
                        icon: Icons.add_box,
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddItemScreen()),
                        ),
                      ),
                      _ActionCard(
                        title: 'Scan QR Code',
                        icon: Icons.qr_code_scanner,
                        color: Colors.blue,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QrScannerScreen()),
                        ),
                      ),
                      _ActionCard(
                        title: 'Cari Manual',
                        icon: Icons.search,
                        color: Colors.purple,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ManualSearchScreen()),
                        ),
                      ),
                      _ActionCard(
                        title: 'Riwayat',
                        icon: Icons.history,
                        color: Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ActivityLogScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Admin extras
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const UserListScreen()),
                          ),
                          icon: const Icon(Icons.people),
                          label: const Text('Daftar Pengguna'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recent items
                  const Text(
                    'Barang Terbaru',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (inventory.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (inventory.items.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Belum ada barang',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    )
                  else
                    ...inventory.items.take(5).map(
                          (item) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF1B2A4A),
                                child: Text(
                                  item.name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(item.name),
                              subtitle: Text(
                                  '${item.itemCode} • Stok: ${item.stock}'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemDetailScreen(item: item),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<AuthProvider>().signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: color.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
