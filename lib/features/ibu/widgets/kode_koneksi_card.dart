import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/warna_utama.dart';

class KodeKoneksiCard extends StatelessWidget {
  final String kode;

  const KodeKoneksiCard({
    super.key,
    required this.kode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WarnaUtama.form,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KODE KONEKSI PASANGAN',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: WarnaUtama.text3,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                kode,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: WarnaUtama.text3,
                  letterSpacing: 4,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: kode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Kode disalin!'),
                      backgroundColor: WarnaUtama.secondary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: WarnaUtama.text2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.copy_outlined,
                    size: 20,
                    color: WarnaUtama.text3.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Bagikan kode koneksi ini dengan pasangan Anda, untuk menyinkronkan akun dan berbagi wawasan.',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              color: WarnaUtama.text3.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}