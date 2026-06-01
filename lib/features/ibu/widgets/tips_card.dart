import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class TipsCard extends StatelessWidget {
  final String title;
  final String duration;
  final IconData icon;
  final VoidCallback? onTap;

  const TipsCard({
    super.key,
    required this.title,
    required this.duration,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
        color: WarnaUtama.text2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: WarnaUtama.primary.withOpacity(0.1),
            child: Icon(icon, size: 16, color: WarnaUtama.primary),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color : WarnaUtama.text1,
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            duration,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Manrope', 
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color : WarnaUtama.text1.withOpacity(0.6)
            ),
          ),
        ],
      ),
    );
  }
}