import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class CardHeader extends StatelessWidget {
  final String title;
  final IconData leftIcon;
  final IconData rightIcon;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;

  const CardHeader({
    super.key,
    required this.title,
    required this.leftIcon,
    required this.rightIcon,
    this.onLeftTap,
    this.onRightTap,
  });

  Widget _iconButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: WarnaUtama.text2,
          shape: BoxShape.circle,
          border: Border.all(
            color: WarnaUtama.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: WarnaUtama.text1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _iconButton(leftIcon, onLeftTap),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: WarnaUtama.text1,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _iconButton(rightIcon, onRightTap),
      ],
    );
  }
}