import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../../services/auth_service.dart';
import '../views/login.dart';

class KeluarAkun {
  static Future<void> show(BuildContext context) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: WarnaUtama.background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: WarnaUtama.beresiko.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: WarnaUtama.beresiko,
                  size: 30,
                ),
              ),

              const SizedBox(height: 16),

              // Judul
              const Text(
                'Keluar Akun',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: WarnaUtama.text1,
                ),
              ),

              const SizedBox(height: 8),

              // Subjudul
              Text(
                'Apakah kamu yakin ingin keluar?\nKamu perlu login ulang untuk masuk.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  color: WarnaUtama.text1.withOpacity(0.5),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Tombol
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: WarnaUtama.form,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Batal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: WarnaUtama.text1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: WarnaUtama.beresiko,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Keluar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (konfirmasi == true && context.mounted) {
      await AuthService.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
        );
      }
    }
  }
}