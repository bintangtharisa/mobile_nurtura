import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import 'notifikasi_item.dart';

class NotifikasiSection extends StatelessWidget {
  final String label;
  final bool isNew;
  final List<Map<String, dynamic>> items;

  const NotifikasiSection({
    super.key,
    required this.label,
    required this.items,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: WarnaUtama.text1.withOpacity(0.4),
                letterSpacing: 1,
              ),
            ),
            if (isNew)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => NotifikasiItem(
              judul: item['judul'] as String,
              deskripsi: item['deskripsi'] as String,
              tipe: item['tipe'] as String,
              berisiko: item['berisiko'] as bool? ?? false,
            )),
      ],
    );
  }
}