// profil.dart
import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';
import '../widgets/profil_avatar.dart';
import '../widgets/kode_koneksi_card.dart';
import '../widgets/koneksi_pasangan_card.dart';
import '../widgets/pengaturan_list.dart';
import '../views/edit_profil.dart';

class ProfilPage extends StatelessWidget {
  final VoidCallback? onBack;

  const ProfilPage({super.key, this.onBack});

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
                onLeftTap: () => onBack?.call(),
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

                    // Avatar
                    Center(
                      child: ProfilAvatar(
                        nama: 'Minju Kim',
                        email: 'kim.minju@email.com',
                        foto: const NetworkImage('https://picsum.photos/id/64/200/200'),
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

                    // Kode koneksi
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
                    const KodeKoneksiCard(kode: '742 891'),

                    const SizedBox(height: 24),

                    // Koneksi pasangan — ganti status sesuai kondisi
                    KoneksiPasanganCard(
                      status: StatusKoneksi.terkoneksi,
                      namaPasangan: 'Harry Potter',
                      terhubungSejak: 'April 2023',
                      fotoPasangan: const NetworkImage('https://picsum.photos/id/91/200/200'),
                      onDisconnect: () {},
                    ),

                    const SizedBox(height: 24),

                    // Pengaturan
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