// koneksi_pasangan_card.dart
import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

enum StatusKoneksi { belumAda, adaRequest, terkoneksi }

class KoneksiPasanganCard extends StatelessWidget {
  final StatusKoneksi status;
  final String? namaPasangan;
  final String? terhubungSejak;
  final ImageProvider? fotoPasangan;
  final int jumlahRequest;
  final VoidCallback? onTerima;
  final VoidCallback? onTolak;
  final VoidCallback? onDisconnect;

  const KoneksiPasanganCard({
    super.key,
    required this.status,
    this.namaPasangan,
    this.terhubungSejak,
    this.fotoPasangan,
    this.jumlahRequest = 0,
    this.onTerima,
    this.onTolak,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Text(
              status == StatusKoneksi.adaRequest
                  ? 'Permintaan yang Tertunda'
                  : 'Kelola Koneksi Pasangan',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WarnaUtama.text1,
              ),
            ),
            if (status == StatusKoneksi.adaRequest && jumlahRequest > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: WarnaUtama.primary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$jumlahRequest NEW',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: WarnaUtama.text1,
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 12),

        if (status == StatusKoneksi.belumAda)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: WarnaUtama.text2,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Belum ada koneksi pasangan. Bagikan kode koneksi di atas.',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                color: WarnaUtama.text1.withOpacity(0.5),
              ),
            ),
          ),

        if (status == StatusKoneksi.adaRequest)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: WarnaUtama.text2,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: fotoPasangan,
                  backgroundColor: WarnaUtama.primary.withOpacity(0.3),
                  child: fotoPasangan == null
                      ? Icon(Icons.person, color: WarnaUtama.secondary)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaPasangan ?? '-',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: WarnaUtama.text1,
                        ),
                      ),
                      Text(
                        'Meminta untuk terhubung',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          color: WarnaUtama.text1.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onTerima,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: WarnaUtama.secondary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, size: 18, color: WarnaUtama.secondary),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onTolak,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: WarnaUtama.beresiko.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18, color: WarnaUtama.beresiko),
                  ),
                ),
              ],
            ),
          ),

        if (status == StatusKoneksi.terkoneksi)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: WarnaUtama.text2,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: fotoPasangan,
                  backgroundColor: WarnaUtama.primary.withOpacity(0.3),
                  child: fotoPasangan == null
                      ? Icon(Icons.person, color: WarnaUtama.secondary)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaPasangan ?? '-',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: WarnaUtama.text1,
                        ),
                      ),
                      Text(
                        'Pasangan • Terhubung sejak $terhubungSejak',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          color: WarnaUtama.text1.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onDisconnect,
                  child: Text(
                    'Disconnect',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: WarnaUtama.beresiko.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}