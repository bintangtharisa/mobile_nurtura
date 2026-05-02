import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../views/beranda.dart';
import '../views/prediksi.dart';
import '../views/riwayat.dart';
import '../views/profil.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const BerandaPage(),
    PrediksiPage(onBack: () => setState(() => _selectedIndex = 0)),
    RiwayatPage(onBack: () => setState(() => _selectedIndex = 0)),
    ProfilPage(onBack: () => setState(() => _selectedIndex = 0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}