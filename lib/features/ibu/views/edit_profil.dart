// edit_profil.dart
import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';
import '../widgets/edit_profil_card.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final _namaController = TextEditingController(text: 'Minju Kim');
  final _emailController = TextEditingController(text: 'kim.minju@email.com');

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: 'Edit Profil',
                leftIcon: Icons.chevron_left,
                onLeftTap: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    EditProfilCard(
                      namaController: _namaController,
                      emailController: _emailController,
                      foto: const NetworkImage('https://picsum.photos/id/64/200/200'),
                      onGantiFoto: () {
                        // TODO: image picker
                      },
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        // TODO: simpan perubahan
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: WarnaUtama.secondary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Simpan Perubahan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: WarnaUtama.text2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}