import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class FilterKategori extends StatefulWidget {
  final List<Map<String, dynamic>> kategori;
  final Function(int)? onSelected;

  const FilterKategori({
    super.key,
    required this.kategori,
    this.onSelected,
  });

  @override
  State<FilterKategori> createState() => _FilterKategoriState();
}

class _FilterKategoriState extends State<FilterKategori> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.kategori.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          final label = widget.kategori[index]['label'] as String;
          final icon = widget.kategori[index]['icon'] as IconData?;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onSelected?.call(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? WarnaUtama.secondary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? WarnaUtama.secondary
                      : WarnaUtama.text1.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 14,
                      color: isSelected ? WarnaUtama.text2 : WarnaUtama.text1,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? WarnaUtama.text2 : WarnaUtama.text1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}