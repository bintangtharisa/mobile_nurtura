import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class KoneksiPasanganCard extends StatelessWidget {
  final String namaPasangan;
  final ImageProvider? fotoPasangan;

  const KoneksiPasanganCard({
    super.key,
    required this.namaPasangan,
    this.fotoPasangan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: WarnaUtama.form,
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
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KONEKSI PASANGAN',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: WarnaUtama.secondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Terhubung dengan $namaPasangan',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: WarnaUtama.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}