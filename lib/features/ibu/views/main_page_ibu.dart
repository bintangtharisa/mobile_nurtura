import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../views/beranda.dart';

class MainPageIbu extends StatefulWidget {
  const MainPageIbu({super.key});

  @override
  State<MainPageIbu> createState() => _MainPageState();
}

class _MainPageState extends State<MainPageIbu> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    BerandaPage(),
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