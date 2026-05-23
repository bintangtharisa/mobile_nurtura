import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/profil_avatar.dart';
import '../widgets/koneksi_pasangan_ayah.dart';
import '../../shared/widgets/pengaturan_list.dart';
import '../../shared/views/edit_profil.dart';

class ProfilAyahPage extends StatelessWidget {
  final VoidCallback? onBack;

  const ProfilAyahPage({super.key, this.onBack});

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
                onLeftTap: () => onBack?.call(),
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
                        nama: 'Harry Potter',
                        email: 'harry.potter@email.com',
                        foto: const NetworkImage('https://picsum.photos/id/91/200/200'),
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

                    KoneksiPasanganCard(
                      namaPasangan: 'Kim Minju',
                      fotoPasangan: const NetworkImage('https://picsum.photos/id/64/200/200'),
                    ),

                    const SizedBox(height: 24),

                    // Pengaturan
                    PengaturanList(
                      showNotifikasi: false,
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