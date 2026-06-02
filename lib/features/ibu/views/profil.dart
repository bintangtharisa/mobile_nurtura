import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/profil_avatar.dart';
import '../widgets/kode_koneksi_card.dart';
import '../widgets/koneksi_pasangan_card.dart';
import '../../shared/widgets/pengaturan_list.dart';
import '../../shared/views/edit_profil.dart';
import '../../../services/auth_service.dart';
import '../../../services/session.dart';
import '../../shared/widgets/ubah_sandi.dart';
import '../../shared/widgets/keluar_akun.dart';
import '../../../utils/api.dart';

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

  Future<void> _terimaKoneksi() async {
    final pendingRequest = _koneksi?['pending_request'];
    final fatherId = pendingRequest?['id'];
    if (fatherId == null) return;

    final confirmed = await _showConfirmDialog(
      title: 'Terima koneksi?',
      message:
          'Father ini akan terhubung dengan akun Anda dan dapat melihat report yang dibagikan.',
      confirmText: 'Terima',
    );
    if (!confirmed) return;

    final res = await AuthService.terimaKoneksi(fatherId);
    if (!mounted) return;
    if (res['success']) {
      await Session.saveConnectedFather({
        'id': fatherId,
        'name': pendingRequest?['name'] ?? 'Father',
        'email': pendingRequest?['email'],
        'sejak': DateTime.now().toIso8601String(),
      });
      await _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi berhasil diterima!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Gagal terima koneksi')),
      );
    }
  }

  Future<void> _tolakKoneksi() async {
    final fatherId = _koneksi?['pending_request']?['id'];
    if (fatherId == null) return;

    final confirmed = await _showConfirmDialog(
      title: 'Tolak request?',
      message:
          'Father ini akan diblock permanen dan tidak dapat menggunakan kode koneksi ini lagi.',
      confirmText: 'Tolak',
      isDanger: true,
    );
    if (!confirmed) return;

    final res = await AuthService.tolakKoneksiByFatherId(fatherId);
    if (!mounted) return;
    if (res['success']) {
      await Session.clearConnectedFather();
      await _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permintaan koneksi ditolak.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Gagal tolak koneksi')),
      );
    }
  }

  Future<void> _blockKoneksi() async {
    final fatherId = _koneksi?['pasangan']?['id'];
    if (fatherId == null) return;

    final confirmed = await _showConfirmDialog(
      title: 'Block koneksi?',
      message:
          'Anda akan block father ini selamanya. Setelah diblock, father tidak dapat mengakses report Anda lagi dan tidak dapat menggunakan koneksi ini kembali.',
      confirmText: 'Block',
      isDanger: true,
    );
    if (!confirmed) return;

    final res = await AuthService.blockKoneksiByFatherId(fatherId);
    if (!mounted) return;
    if (res['success']) {
      await Session.clearConnectedFather();
      await _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi berhasil diblock.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Gagal block koneksi')),
      );
    }
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmText,
    bool isDanger = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmText,
              style: TextStyle(
                color: isDanger ? WarnaUtama.beresiko : WarnaUtama.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  StatusKoneksi _getStatusKoneksi() {
    if (_koneksi?['pasangan'] != null) return StatusKoneksi.terkoneksi;
    if (_koneksi?['pending_request'] != null) return StatusKoneksi.adaRequest;
    return StatusKoneksi.belumAda;
  }

  ImageProvider _getFotoPasangan() {
    final foto = _koneksi?['pasangan']?['photo']
        ?? _koneksi?['pending_request']?['photo'];
    if (foto != null) return NetworkImage(foto);
    return const AssetImage('assets/images/logo_nurtura.png');
  }

  ImageProvider _getFotoProfil() {
    final photo = _user?['photo'];
    if (photo != null && photo.toString().isNotEmpty) {
      return NetworkImage('${Api.storageUrl}/$photo');
    }
    return const AssetImage('assets/images/logo_nurtura.png');
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
                        foto: _getFotoProfil(),
                        onEdit: () async {
                          final photo = _user?['photo'];
                          final initialFoto = photo != null && photo.toString().isNotEmpty
                              ? '${Api.storageUrl}/$photo'
                              : null;
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfilPage(
                                initialName: _user?['name'] ?? '',
                                initialEmail: _user?['email'] ?? '',
                                initialFoto: initialFoto,
                              ),
                            ),
                          );
                          if (result == true) {
                            await _loadData();
                          }
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
                      status: _getStatusKoneksi(),
                      namaPasangan: _koneksi?['pasangan']?['name']
                          ?? _koneksi?['pending_request']?['name'] ?? '',
                      terhubungSejak: _koneksi?['pasangan']?['sejak'] ?? '',
                      fotoPasangan: _getFotoPasangan(),
                      jumlahRequest: _koneksi?['pending_request'] != null ? 1 : 0,
                      onTerima: _terimaKoneksi,
                      onTolak: _tolakKoneksi,
                      onDisconnect: _blockKoneksi,
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