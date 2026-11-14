import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xFF1B2A4A),
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final profile = auth.profile;
          if (profile == null) {
            return const Center(child: Text('Tidak ada data profil'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Avatar
                CircleAvatar(
                  radius: 48,
                  backgroundColor: const Color(0xFF1B2A4A),
                  child: Text(
                    profile.fullName.isNotEmpty
                        ? profile.fullName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  profile.fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: profile.isAdmin
                        ? Colors.orange[100]
                        : Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    profile.isAdmin ? 'Admin' : 'User',
                    style: TextStyle(
                      color: profile.isAdmin
                          ? Colors.orange[800]
                          : Colors.blue[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Profile Info
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Email'),
                        subtitle: Text(profile.email),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.badge_outlined),
                        title: const Text('Role'),
                        subtitle:
                            Text(profile.isAdmin ? 'Administrator' : 'User'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.calendar_today_outlined),
                        title: const Text('Terdaftar Sejak'),
                        subtitle: Text(
                          '${profile.createdAt.day}/${profile.createdAt.month}/${profile.createdAt.year}',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Logout
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<AuthProvider>().signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}
