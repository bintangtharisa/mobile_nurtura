import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../views/beranda.dart';

class MainPageAyah extends StatefulWidget {
  const MainPageAyah({super.key});

  @override
  State<MainPageAyah> createState() => _MainPageState();
}

class _MainPageState extends State<MainPageAyah> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    BerandaAyahPage(),
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