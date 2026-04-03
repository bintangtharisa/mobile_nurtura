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

  return Expanded(
    child: GestureDetector(
      onTap: () => onSelected(role),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? roleColor.withOpacity(0.1) // background 10%
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? roleColor // 100%
                : roleColor.withOpacity(0.6), // 60%
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.person,
              size: 30,
              color: isSelected
                  ? roleColor // 100%
                  : roleColor.withOpacity(0.6), // 60%
            ),
            SizedBox(height: 8),
            Text(
              role,
              style: TextStyle(
                fontSize: 18,
                color: WarnaUtama.text1, // text tetap solid
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}