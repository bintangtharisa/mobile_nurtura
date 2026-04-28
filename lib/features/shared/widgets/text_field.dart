import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final bool obscure;
  final IconData? icon;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.icon,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // 👈 TAMBAHKAN INI (PENTING)
      obscureText: isObscure,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w500,
        color: WarnaUtama.text1,
      ),

      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontFamily: 'Manrope',
          color: WarnaUtama.text1.withOpacity(0.6),
        ),

        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: WarnaUtama.text1.withOpacity(0.6))
            : null,

        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: WarnaUtama.text1.withOpacity(0.6),
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )
            : null,

        filled: true,
        fillColor: WarnaUtama.form,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
