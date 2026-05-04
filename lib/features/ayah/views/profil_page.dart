import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../../services/auth_service.dart';
import '../../../services/session.dart';
import '../../shared/views/login.dart';

class ProfilAyahPage extends StatefulWidget {
  const ProfilAyahPage({super.key});

  @override
  State<ProfilAyahPage> createState() => _ProfilAyahPageState();
}

class _ProfilAyahPageState extends State<ProfilAyahPage> {
  String nama = "";
  String email = "";
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
        nama = res['data']['name'] ?? "";
        email = res['data']['email'] ?? "";
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _logout() async {
    await Session.saveToken('');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Profil",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: WarnaUtama.text1,
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    const SizedBox(height: 12),
                    isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            nama,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: WarnaUtama.text1,
                            ),
                          ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 14,
                        color: WarnaUtama.text1.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WarnaUtama.primary, width: 1.5),
                ),
                child: Column(
                  children: [
                    _infoRow(Icons.person_outline, "Nama", nama),
                    const Divider(),
                    _infoRow(Icons.email_outlined, "Email", email),
                    const Divider(),
                    _infoRow(Icons.shield_outlined, "Role", "Ayah"),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Keluar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: WarnaUtama.secondary, size: 20),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: WarnaUtama.text1,
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: TextStyle(
                color: WarnaUtama.text1.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}