import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../../services/auth_service.dart';

class UbahSandiSheet extends StatefulWidget {
  const UbahSandiSheet({super.key});

  @override
  State<UbahSandiSheet> createState() => _UbahSandiSheetState();
}

class _UbahSandiSheetState extends State<UbahSandiSheet> {
  final _lamaCon = TextEditingController();
  final _baruCon = TextEditingController();
  bool _isLoading = false;
  bool _obscureLama = true;
  bool _obscureBaru = true;
  String? _error;

  @override
  void dispose() {
  _lamaCon.dispose();
  _baruCon.dispose();
  super.dispose();
  }

Widget _inputField({
  required String label,
  required TextEditingController controller,
  required bool obscure,
  required VoidCallback onToggle,
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
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: WarnaUtama.form,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: WarnaUtama.text1.withOpacity(0.4),
                size: 20,
              ),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: WarnaUtama.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: WarnaUtama.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Ubah Sandi',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WarnaUtama.text1,
              ),
            ),

            const SizedBox(height: 20),

            _inputField(
              label: 'Sandi Lama',
              controller: _lamaCon,
              obscure: _obscureLama,
              onToggle: () => setState(() => _obscureLama = !_obscureLama),
            ),
            const SizedBox(height: 14),
            _inputField(
              label: 'Sandi Baru',
              controller: _baruCon,
              obscure: _obscureBaru,
              onToggle: () => setState(() => _obscureBaru = !_obscureBaru),
            ),

            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  color: WarnaUtama.beresiko,
                  fontSize: 12,
                ),
              ),
            ],

            const SizedBox(height: 20),

            GestureDetector(
              onTap: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                        _error = null;
                      });
                      final res = await AuthService.changePassword(
                        passwordLama: _lamaCon.text,
                        passwordBaru: _baruCon.text,
                      );
                      setState(() => _isLoading = false);
                      if (res['success']) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Sandi berhasil diubah!'),
                            backgroundColor: WarnaUtama.secondary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      } else {
                        setState(() => _error = res['message']);
                      }
                    },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _isLoading
                      ? WarnaUtama.secondary.withOpacity(0.5)
                      : WarnaUtama.secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: WarnaUtama.text2,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}