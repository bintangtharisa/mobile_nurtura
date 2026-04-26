import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class AksiCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool fullWidth;

  const AksiCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: WarnaUtama.text2),
            ),
          ),
          const SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }
}