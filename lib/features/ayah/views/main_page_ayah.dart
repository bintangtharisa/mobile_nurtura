import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../views/beranda.dart';
import '../views/monitoring_kondisi.dart';
import '../views/panduan_dukungan.dart';
import '../views/profil_ayah.dart';

class MainPageAyah extends StatefulWidget {
  const MainPageAyah({super.key});

  @override
  State<MainPageAyah> createState() => _MainPageAyahState();
}

class _MainPageAyahState extends State<MainPageAyah> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          BerandaAyahPage(),
          MonitoringKondisiPage(),
          PanduanDukunganPage(),
          ProfilAyahPage(),
        ],
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}