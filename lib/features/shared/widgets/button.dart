import "package:flutter/material.dart";
import '../../../core/theme/warna_utama.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: WarnaUtama.secondary,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      onPressed: onPressed,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: WarnaUtama.text2,
              ),
              SizedBox(width: 8),
            ],

          Text(text,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: WarnaUtama.text2,
            ),
          ),
        ],
      ),
    ),
    );
  }
}