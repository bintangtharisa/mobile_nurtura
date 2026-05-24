import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/profil_avatar.dart';
import '../widgets/kode_koneksi_card.dart';
import '../widgets/koneksi_pasangan_card.dart';
import '../../shared/widgets/pengaturan_list.dart';
import '../../shared/views/edit_profil.dart';
import '../../../services/auth_service.dart';
import '../../shared/widgets/ubah_sandi.dart';
import '../../shared/widgets/keluar_akun.dart';

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
      print("USER RESULT: $userRes");
      if (userRes['success']) {
        setState(() => _user = userRes['data']);
      } else {
        print("USER ERROR: ${userRes['message']}");
      }

      final koneksiRes = await AuthService.getKoneksi();
      print("KONEKSI RESULT: $koneksiRes");
      if (koneksiRes['success']) {
        setState(() => _koneksi = koneksiRes['data']);
      } else {
        print("KONEKSI ERROR: ${koneksiRes['message']}");
      }
    } catch (e) {
      print("LOAD DATA ERROR: $e");
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
                        foto: _user?['photo'] != null
                            ? NetworkImage(_user!['photo'])
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
                      kode: _user?['connection_code'] ?? '------',
                    ),
                    const SizedBox(height: 24),
                    KoneksiPasanganCard(
                      status: _koneksi?['pasangan'] != null
                          ? StatusKoneksi.terkoneksi
                          : StatusKoneksi.belumAda,
                      namaPasangan: _koneksi?['pasangan']?['name'] ?? '',
                      terhubungSejak: _koneksi?['pasangan']?['sejak'] ?? '',
                      fotoPasangan: _koneksi?['pasangan']?['photo'] != null
                          ? NetworkImage(_koneksi!['pasangan']['photo'])
                          : const NetworkImage('https://picsum.photos/id/91/200/200'),
                      onDisconnect: () {},
                    ),
                    const SizedBox(height: 24),
                    PengaturanList(
                      onUbahSandi: () {
                        showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const UbahSandiSheet(),
                        );
                      },
                      onKeluarAkun: () => KeluarAkun.show(context),
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