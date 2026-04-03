import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool obscure;

  const CustomTextField({
    super.key,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: WarnaUtama.form,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}