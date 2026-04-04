import "package:flutter/material.dart";
import '../../../core/theme/warna_utama.dart';

class PilihRole extends StatelessWidget {
  final String selectedRole;
  final Function(String) onSelected;

  const PilihRole({
    super.key,
    required this.selectedRole,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildItem("Ibu"),
        SizedBox(width: 12),
        _buildItem("Ayah"),
      ],
    );
  }
  
  Widget _buildItem(String role) {
    final isSelected = selectedRole == role;
    final roleColor = role == "Ibu"
        ? WarnaUtama.primary
        : WarnaUtama.secondary;
    final roleIcon = role == "Ibu"
        ? Icons.female
        : Icons.male;

  return Expanded(
    child: GestureDetector(
      onTap: () => onSelected(role),
      child: AnimatedScale(
        duration: Duration(milliseconds: 200),
        scale: isSelected ? 1.02 : 1.0,

        child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? roleColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? roleColor
                : roleColor.withOpacity(0.6),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              roleIcon,
              size: 28,
              color: isSelected
                  ? roleColor
                  : roleColor.withOpacity(0.6),
            ),
            SizedBox(height: 6),
            Text(
              role,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: WarnaUtama.text1,
              ),
            ),
          ],
        ),
      ),
    ),
   )
    );
}
}