import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class TombolNavigasiSkrining extends StatelessWidget {
  final VoidCallback? onSebelumnya;
  final VoidCallback? onSelanjutnya;
  final bool isFirst;
  final bool isLast;

  const TombolNavigasiSkrining({
    super.key,
    this.onSebelumnya,
    this.onSelanjutnya,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isFirst) ...[
          Expanded(
            child: GestureDetector(
              onTap: onSebelumnya,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: WarnaUtama.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_back, size: 16, color: WarnaUtama.text1),
                    SizedBox(width: 8),
                    Text(
                      'Sebelumnya',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: WarnaUtama.text1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: GestureDetector(
            onTap: onSelanjutnya,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: WarnaUtama.secondary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLast ? 'Selesai' : 'Selanjutnya',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: WarnaUtama.text2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isLast ? Icons.check : Icons.arrow_forward,
                    size: 16,
                    color: WarnaUtama.text2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}