import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/profil_avatar.dart';
import '../widgets/koneksi_pasangan_ayah.dart';
import '../../shared/widgets/pengaturan_list.dart';
import '../../shared/views/edit_profil.dart';
import '../../shared/views/login.dart';
import '../../../services/auth_service.dart';

class ProfilAyahPage extends StatefulWidget {
  final VoidCallback? onBack;

  const ProfilAyahPage({super.key, this.onBack});

  @override
  State<ProfilAyahPage> createState() => _ProfilAyahPageState();
}

class _ProfilAyahPageState extends State<ProfilAyahPage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final userResult = await AuthService.getUser();

      if (userResult['success'] == true) {
        setState(() {
          userData = userResult['data'];
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal memuat data: $e';
      });
    }
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Ubah Sandi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Sandi Lama',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Sandi Baru',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (currentPasswordController.text.isEmpty ||
                          newPasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Semua field wajib diisi')),
                        );
                        return;
                      }

                      setDialogState(() {
                        isSaving = true;
                      });

                      try {
                        print('CHANGE PASSWORD: Memulai proses ubah sandi');
                        print('CHANGE PASSWORD: Sandi lama length: ${currentPasswordController.text.length}');
                        print('CHANGE PASSWORD: Sandi baru length: ${newPasswordController.text.length}');

                        final result = await AuthService.changePassword(
                          passwordLama: currentPasswordController.text,
                          passwordBaru: newPasswordController.text,
                        );

                        print('CHANGE PASSWORD RESULT: $result');

                        if (result['success'] == true) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sandi berhasil diubah')),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      result['message'] ?? 'Gagal mengubah sandi')),
                            );
                          }
                        }
                      } catch (e) {
                        print('CHANGE PASSWORD ERROR: $e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      } finally {
                        if (context.mounted) {
                          setDialogState(() {
                            isSaving = false;
                          });
                        }
                      }
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WarnaUtama.beresiko,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: 'Profil & Koneksi',
                leftIcon: Icons.chevron_left,
                onLeftTap: () => widget.onBack?.call(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (errorMessage != null)
                      Center(
                        child: Column(
                          children: [
                            Text(errorMessage!,
                                style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadData,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      // Avatar
                      Center(
                        child: ProfilAvatar(
                          nama: userData?['name'] ?? 'Nama tidak tersedia',
                          email: userData?['email'] ?? 'Email tidak tersedia',
                          foto: userData?['photo'] != null
                              ? NetworkImage(userData!['photo'])
                              : const NetworkImage('https://picsum.photos/id/91/200/200'),
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfilPage(
                                  initialName: userData?['name'],
                                  initialEmail: userData?['email'],
                                ),
                              ),
                            ).then((_) => _loadData());
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Kelola Koneksi Pasangan
                      const Text(
                        'Kelola Koneksi Pasangan',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: WarnaUtama.text1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (userData != null &&
                          userData!['connection'] != null &&
                          userData!['connection']['is_connected'] == true &&
                          userData!['connection']['mother'] != null)
                        KoneksiPasanganCard(
                          namaPasangan: userData!['connection']['mother']['username'] ?? 'Pasangan tidak tersedia',
                          fotoPasangan: const NetworkImage('https://picsum.photos/id/64/200/200'),
                        )
                      else
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Belum ada koneksi pasangan'),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Pengaturan
                      PengaturanList(
                        showNotifikasi: false,
                        onUbahSandi: _showChangePasswordDialog,
                        onKeluarAkun: _showLogoutDialog,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}