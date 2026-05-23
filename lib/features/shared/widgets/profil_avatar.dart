import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class ProfilAvatar extends StatelessWidget {
  final String nama;
  final String email;
  final ImageProvider? foto;
  final VoidCallback? onEdit;

  const ProfilAvatar({
    super.key,
    required this.nama,
    required this.email,
    this.foto,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 52,
              backgroundImage: foto,
              backgroundColor: WarnaUtama.primary.withOpacity(0.3),
              child: foto == null
                  ? Icon(Icons.person, size: 52, color: WarnaUtama.secondary)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEdit,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: WarnaUtama.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: WarnaUtama.text2, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 14, color: WarnaUtama.text2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          nama,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: WarnaUtama.text1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            color: WarnaUtama.text1.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}