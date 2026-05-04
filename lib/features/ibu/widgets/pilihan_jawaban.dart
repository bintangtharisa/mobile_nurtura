import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class PilihanJawaban extends StatelessWidget {
  final List<String> pilihan;
  final int? selectedIndex;
  final Function(int) onSelected;

  const PilihanJawaban({
    super.key,
    required this.pilihan,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(pilihan.length, (index) {
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onSelected(index),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: WarnaUtama.text2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? WarnaUtama.secondary : WarnaUtama.primary.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? WarnaUtama.secondary : WarnaUtama.text1.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: WarnaUtama.secondary,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  pilihan[index],
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: WarnaUtama.text1,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}