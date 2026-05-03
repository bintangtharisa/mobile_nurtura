import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../../services/auth_service.dart';

class HeaderProfil extends StatefulWidget {
  const HeaderProfil({super.key});

  @override
  State<HeaderProfil> createState() => _HeaderProfilState();
}

class _HeaderProfilState extends State<HeaderProfil> {
  String nama = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final res = await AuthService.getUser();
    if (res['success']) {
      setState(() {
        nama = res['data']['name'] ?? "Ayah";
        isLoading = false;
      });
    } else {
      setState(() {
        nama = "Ayah";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: WarnaUtama.text2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WarnaUtama.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLoading ? "Memuat..." : "Halo, $nama!",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: WarnaUtama.text1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Selamat datang kembali! Bagaimana kabarmu hari ini?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: WarnaUtama.secondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: WarnaUtama.text2,
              shape: BoxShape.circle,
              border: Border.all(color: WarnaUtama.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              size: 24,
              color: WarnaUtama.text1,
            ),
          ),
        ],
      ),
    );
  }
}