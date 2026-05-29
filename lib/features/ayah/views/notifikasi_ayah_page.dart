import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/notifikasi_section.dart';

class NotifikasiAyahPage extends StatelessWidget {
  const NotifikasiAyahPage({super.key});

  static const List<Map<String, dynamic>> _notifikasiList = [
    {
      'section': 'HARI INI',
      'isNew': true,
      'items': [
        {
          'judul': 'Kondisi Istri Berisiko Mengalami Kecemasan',
          'deskripsi': 'Pastikan ibu mendapatkan waktu istirahat yang cukup dan dukungan emosional dari keluarga.',
          'tipe': 'peringatan',
          'berisiko': true,
        },
      ],
    },
    {
      'section': 'KEMARIN',
      'isNew': false,
      'items': [
        {
          'judul': 'Kondisi Istri Terpantau Stabil',
          'deskripsi': 'Pemantauan terakhir menunjukkan kondisi emosional ibu dalam keadaan baik.',
          'tipe': 'stabil',
          'berisiko': false,
        },
      ],
    },
    {
      'section': '26 MEI 2026',
      'isNew': false,
      'items': [
        {
          'judul': 'Kondisi Istri Terpantau Stabil',
          'deskripsi': 'Pemantauan terakhir menunjukkan kondisi emosional ibu dalam keadaan baik.',
          'tipe': 'stabil',
          'berisiko': false,
        },
        {
          'judul': 'Koneksi Berhasil Terhubung',
          'deskripsi': 'Akun anda sekarang telah terhubung dengan istri anda.',
          'tipe': 'koneksi',
          'berisiko': false,
        },
      ],
    },
  ];

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
                title: 'Riwayat Notifikasi',
                leftIcon: Icons.chevron_left,
                onLeftTap: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._notifikasiList.map((section) => NotifikasiSection(
                          label: section['section'] as String,
                          isNew: section['isNew'] as bool,
                          items: List<Map<String, dynamic>>.from(section['items']),
                        )),

                    // Footer
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: WarnaUtama.primary.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.history,
                              color: WarnaUtama.text1.withOpacity(0.3),
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'SEMUA PEMBERITAHUAN TELAH DITAMPILKAN',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: WarnaUtama.text1.withOpacity(0.3),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
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