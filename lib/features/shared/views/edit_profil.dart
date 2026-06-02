import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';
import '../widgets/edit_profil_card.dart';
import '../../../services/auth_service.dart';

class EditProfilPage extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;
  final String? initialFoto;

  const EditProfilPage({
    super.key,
    this.initialName,
    this.initialEmail,
    this.initialFoto,
  });

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  XFile? _fotoFile;
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

  Future<void> _pilihFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _fotoFile = picked);
    }
  }

  Future<void> _saveChanges() async {
    if (_namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama wajib diisi')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      // Upload foto dulu jika user memilih foto baru
      if (_fotoFile != null) {
        final fotoResult = await AuthService.updatePhoto(_fotoFile!);
        if (!mounted) return;
        if (fotoResult['success'] != true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(fotoResult['message'] ?? 'Gagal upload foto'),
            ),
          );
          setState(() => isSaving = false);
          return;
        }
      }

      // Update nama
      final result = await AuthService.updateProfil(
        nama: _namaController.text,
        email: _emailController.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal memperbarui profil'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider? fotoProvider =
    widget.initialFoto != null && widget.initialFoto!.isNotEmpty
        ? NetworkImage(widget.initialFoto!)
        : null;

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
                      foto: fotoProvider, // sudah tidak nullable
                      fotoFile: _fotoFile,
                      onGantiFoto: _pilihFoto,
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
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