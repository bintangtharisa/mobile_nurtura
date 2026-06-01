import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../views/beranda.dart';
import '../views/prediksi.dart';
import '../views/riwayat.dart';
import '../views/profil.dart';
import '../../../services/notification_service.dart';

class MainPageIbu extends StatefulWidget {
  const MainPageIbu({super.key});

  @override
  State<MainPageIbu> createState() => _MainPageIbuState();
}

class _MainPageIbuState extends State<MainPageIbu> {
  int _selectedIndex = 0;

  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    pages.addAll([
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[_selectedIndex],

          /// 🔥 DEBUG BUTTON (TEMPORARY)
          Positioned(
            bottom: 100,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                await NotificationService.triggerReminder();
              },
              child: const Text("Trigger Notif"),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}