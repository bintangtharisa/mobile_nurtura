import 'dart:io';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/warna_utama.dart';

class EditProfilCard extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController emailController;
  final ImageProvider? foto;
  final XFile? fotoFile;
  final VoidCallback? onGantiFoto;

  const EditProfilCard({
    super.key,
    required this.namaController,
    required this.emailController,
    this.foto,
    this.fotoFile,
    this.onGantiFoto,
  });

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: WarnaUtama.text1.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: WarnaUtama.form,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 15,
            color: WarnaUtama.text1,
          ),
        ),
      ],
    );
  }

  Widget _buildFotoWidget() {
    if (fotoFile != null) {
      // Flutter Web: pakai Image.network dengan path blob URL dari image_picker
      // Flutter Mobile: pakai Image.file
      if (kIsWeb) {
        return Image.network(
          fotoFile!.path,
          width: 104,
          height: 104,
          fit: BoxFit.cover,
        );
      } else {
        return Image.file(
          File(fotoFile!.path),
          width: 104,
          height: 104,
          fit: BoxFit.cover,
        );
      }
    } else if (foto != null) {
      return Image(
        image: foto!,
        width: 104,
        height: 104,
        fit: BoxFit.cover,
      );
    } else {
      return Icon(
        Icons.person,
        size: 52,
        color: WarnaUtama.secondary,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: foto, // bisa null
            backgroundColor: WarnaUtama.primary.withOpacity(0.3),
            child: foto == null
                ? Icon(Icons.person, size: 52, color: WarnaUtama.secondary)
                : null,
          ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onGantiFoto,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: WarnaUtama.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: WarnaUtama.text2,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                    color: WarnaUtama.text2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        _inputField(
          label: 'Nama Lengkap',
          controller: namaController,
        ),
        const SizedBox(height: 16),
        _inputField(
          label: 'Email',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}