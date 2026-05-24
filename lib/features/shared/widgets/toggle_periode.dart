import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class TogglePeriode extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelected;

  const TogglePeriode({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: WarnaUtama.form,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _tombol('Mingguan', 0),
          _tombol('Bulanan', 1),
        ],
      ),
    );
  }

  Widget _tombol(String label, int index) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? WarnaUtama.text2 : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              color: isSelected ? WarnaUtama.text1 : WarnaUtama.text1.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}