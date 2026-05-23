import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';
import '../widgets/edit_profil_card.dart';
import '../../../services/auth_service.dart';

class EditProfilPage extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;

  const EditProfilPage({super.key, this.initialName, this.initialEmail});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  late final _namaController;
  late final _emailController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.initialName ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_namaController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan email wajib diisi')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final result = await AuthService.updateProfil(
        nama: _namaController.text,
        email: _emailController.text,
      );

      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Gagal memperbarui profil')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
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
                      onTap: isSaving ? null : _saveChanges,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSaving ? Colors.grey : WarnaUtama.secondary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: isSaving
                            ? const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              )
                            : const Text(
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