import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class NotifikasiItem extends StatelessWidget {
  final String judul;
  final String deskripsi;
  final String tipe;
  final bool berisiko;

  const NotifikasiItem({
    super.key,
    required this.judul,
    required this.deskripsi,
    required this.tipe,
    this.berisiko = false,
  });

  Widget _iconNotifikasi() {
    if (tipe == 'koneksi') {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Color(0xFF3A3A3A),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 20),
      );
    } else if (berisiko) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.warning_rounded, color: Colors.red, size: 20),
      );
    } else if (tipe == 'skrining') {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: WarnaUtama.secondary.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.calendar_month_outlined,
          color: WarnaUtama.secondary,
          size: 20,
        ),
      );
    } else {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: WarnaUtama.secondary.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.favorite_outline,
          color: WarnaUtama.secondary,
          size: 20,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: berisiko ? Colors.red.withOpacity(0.05) : WarnaUtama.text2,
        borderRadius: BorderRadius.circular(16),
        border: berisiko
            ? Border.all(color: Colors.red.withOpacity(0.2))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconNotifikasi(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: WarnaUtama.text1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  deskripsi,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    color: WarnaUtama.text1.withOpacity(0.5),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}