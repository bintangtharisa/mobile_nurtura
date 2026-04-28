import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class BottomNav extends StatelessWidget {
    final int selectedIndex;
    final ValueChanged<int> onTap;

    const BottomNav({super.key, 
    required this.selectedIndex,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: WarnaUtama.primary,
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        showUnselectedLabels: true,
        selectedItemColor: WarnaUtama.secondary,
        unselectedItemColor: WarnaUtama.text1.withOpacity(0.4),
        backgroundColor: Colors.transparent,
        elevation: 0,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Prediksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}