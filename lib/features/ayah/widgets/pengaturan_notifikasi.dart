import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class PengaturanNotifikasi extends StatefulWidget {
  const PengaturanNotifikasi({super.key});

  @override
  State<PengaturanNotifikasi> createState() => _PengaturanNotifikasiState();
}

class _PengaturanNotifikasiState extends State<PengaturanNotifikasi> {
  bool _hanyaBerisiko = false;
  bool _semuaPerubahan = true;

  Widget _itemNotifikasi({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: WarnaUtama.text2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: WarnaUtama.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: WarnaUtama.secondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: WarnaUtama.text1,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    color: WarnaUtama.text1.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: WarnaUtama.secondary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pengaturan Notifikasi',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: WarnaUtama.text1,
          ),
        ),
        const SizedBox(height: 12),
        _itemNotifikasi(
          icon: Icons.notifications_outlined,
          title: 'Hanya Berisiko Depresi',
          subtitle: 'Notifikasi saat kondisi kritis',
          value: _hanyaBerisiko,
          onChanged: (val) => setState(() => _hanyaBerisiko = val),
        ),
        const SizedBox(height: 10),
        _itemNotifikasi(
          icon: Icons.update,
          title: 'Semua Perubahan',
          subtitle: 'Laporan harian perkembangan',
          value: _semuaPerubahan,
          onChanged: (val) => setState(() => _semuaPerubahan = val),
        ),
      ],
    );
  }
}