import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../views/beranda.dart';
import '../views/prediksi.dart';
import '../views/riwayat.dart';
import '../views/profil.dart';

class MainPageIbu extends StatefulWidget {
  const MainPageIbu({super.key});

  @override
  State<MainPageIbu> createState() => _MainPageState();
}

class _MainPageState extends State<MainPageIbu> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      BerandaPage(
        onKoneksiTap: () {
          setState(() {
            _selectedIndex = 3;
          });
        },
      ),
      PrediksiPage(),
      RiwayatPage(),
      ProfilPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}