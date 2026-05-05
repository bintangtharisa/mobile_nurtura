import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';
import '../widgets/profil_avatar.dart';
import '../widgets/kode_koneksi_card.dart';
import '../widgets/koneksi_pasangan_card.dart';
import '../widgets/pengaturan_list.dart';
import '../views/edit_profil.dart';
import '../../../services/auth_service.dart';

class ProfilPage extends StatefulWidget {
  final VoidCallback? onBack;
  const ProfilPage({super.key, this.onBack});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _koneksi;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userRes = await AuthService.getUser();
      if (userRes['success']) {
        setState(() => _user = userRes['data']);
      }

      final koneksiRes = await AuthService.getKoneksi();
      if (koneksiRes['success']) {
        setState(() => _koneksi = koneksiRes['data']);
      }
    } catch (e) {
      // gagal load
    }
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
                rightIcon: Icons.notifications_outlined,
                onLeftTap: () => widget.onBack?.call(),
                onRightTap: () {},
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    Center(
                      child: ProfilAvatar(
                        nama: _user?['name'] ?? 'Memuat...',
                        email: _user?['email'] ?? '',
                        foto: _user?['foto'] != null
                          ? NetworkImage(_user!['foto'])
                          : const NetworkImage('https://picsum.photos/id/64/200/200'),
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfilPage(),
                            ),
                          );
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

                    KodeKoneksiCard(
                      kode: _koneksi?['kode'] ?? '------',
                    ),

                    const SizedBox(height: 24),

                    KoneksiPasanganCard(
                      status: _koneksi?['pasangan'] != null
                        ? StatusKoneksi.terkoneksi
                        : StatusKoneksi.belumAda,
                      namaPasangan: _koneksi?['pasangan']?['name'] ?? '',
                      terhubungSejak: _koneksi?['pasangan']?['sejak'] ?? '',
                      fotoPasangan: _koneksi?['pasangan']?['foto'] != null
                        ? NetworkImage(_koneksi!['pasangan']['foto'])
                        : const NetworkImage('https://picsum.photos/id/91/200/200'),
                      onDisconnect: () {},
                    ),

                    const SizedBox(height: 24),

                    PengaturanList(
                      onUbahSandi: () {},
                      onKeluarAkun: () {},
                    ),

                    const SizedBox(height: 24),
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