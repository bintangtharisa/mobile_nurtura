import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/profil_avatar.dart';
import '../widgets/koneksi_pasangan_ayah.dart';
import '../../shared/widgets/pengaturan_list.dart';
import '../../shared/views/edit_profil.dart';
import '../../../services/auth_service.dart';
import '../../shared/widgets/ubah_sandi.dart';
import '../../shared/widgets/keluar_akun.dart';

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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UbahSandiSheet(),
    );
  }

  void _showLogoutDialog() {
    KeluarAkun.show(context);
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
                      Center(
                        child: ProfilAvatar(
                          nama: userData?['name'] ?? 'Nama tidak tersedia',
                          email: userData?['email'] ?? 'Email tidak tersedia',
                          foto: userData?['photo'] != null
                              ? NetworkImage(userData!['photo'])
                              : const NetworkImage(
                                  'https://picsum.photos/id/91/200/200'),
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
                          namaPasangan: userData!['connection']['mother']
                                  ['username'] ??
                              'Pasangan tidak tersedia',
                          fotoPasangan: const NetworkImage(
                              'https://picsum.photos/id/64/200/200'),
                        )
                      else
                        const Center(
                          child: Text(
                            'Belum ada koneksi pasangan',
                            style: TextStyle(
                              color: WarnaUtama.text1,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

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