// pengaturan_list.dart
import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class PengaturanList extends StatefulWidget {
  final VoidCallback? onUbahSandi;
  final VoidCallback? onKeluarAkun;

  const PengaturanList({
    super.key,
    this.onUbahSandi,
    this.onKeluarAkun,
  });

  @override
  State<PengaturanList> createState() => _PengaturanListState();
}

class _PengaturanListState extends State<PengaturanList> {
  bool _notifikasi = true;

  Widget _itemPengaturan({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: onTap == null && trailing == null
                          ? WarnaUtama.beresiko
                          : WarnaUtama.text1,
                    ),
                  ),
                  if (subtitle != null)
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
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pengaturan',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: WarnaUtama.text1,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _itemPengaturan(
              icon: Icons.notifications_outlined,
              iconBg: WarnaUtama.secondary.withOpacity(0.15),
              iconColor: WarnaUtama.secondary,
              title: 'Notifikasi',
              subtitle: 'Pengingat jadwal skrining',
              trailing: Switch(
                value: _notifikasi,
                onChanged: (val) => setState(() => _notifikasi = val),
                activeColor: WarnaUtama.secondary,
              ),
            ),
            const SizedBox(height: 10),
            _itemPengaturan(
              icon: Icons.shield_outlined,
              iconBg: WarnaUtama.secondary.withOpacity(0.15),
              iconColor: WarnaUtama.secondary,
              title: 'Ubah Sandi',
              trailing: Icon(
                Icons.chevron_right,
                color: WarnaUtama.text1.withOpacity(0.4),
              ),
              onTap: widget.onUbahSandi,
            ),
            const SizedBox(height: 10),
            _itemPengaturan(
              icon: Icons.logout_rounded,
              iconBg: WarnaUtama.beresiko.withOpacity(0.1),
              iconColor: WarnaUtama.beresiko,
              title: 'Keluar Akun',
              onTap: widget.onKeluarAkun,
            ),
          ],
        ),
      ],
    );
  }
}