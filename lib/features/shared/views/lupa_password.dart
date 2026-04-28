import 'package:flutter/material.dart';
import '../views/login.dart';
import '../views/periksa_email.dart';
import '../../../../core/theme/warna_utama.dart';
import '../widgets/text_field.dart';
import '../widgets/button.dart';
import '../../../services/auth_service.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> handleForgotPassword() async {
    final email = emailController.text.trim();

    // Validasi kosong
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email tidak boleh kosong")),
      );
      return;
    }

    // Validasi sederhana email
    if (!email.contains("@") || !email.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Format email tidak valid")),
      );
      return;
    }

    // Hindari spam klik
    if (isLoading) return;

    setState(() => isLoading = true);

    final result = await AuthService.forgotPassword(email);

    if (!mounted) return; // 🔥 cegah error setelah pindah halaman

    setState(() => isLoading = false);

    print("FORGOT RESULT: $result");

    if (result["success"] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PeriksaEmail(email: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"] ?? "Terjadi kesalahan"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      appBar: AppBar(
        backgroundColor: WarnaUtama.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: WarnaUtama.text1,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "Nurtura",
          style: TextStyle(
            fontFamily: 'Gloock',
            fontSize: 20,
            color: WarnaUtama.text1,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // ICON
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WarnaUtama.secondary.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.local_florist,
                  size: 40,
                  color: WarnaUtama.secondary,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Lupa Kata Sandi?",
                style: TextStyle(
                  fontFamily: 'Gloock',
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: WarnaUtama.text1,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Masukkan email terdaftar Anda untuk mengatur ulang kata sandi.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: WarnaUtama.text1.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Alamat Email",
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: WarnaUtama.text1,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              CustomTextField(
                hint: "nama@gmail.com",
                icon: Icons.email,
                controller: emailController,
              ),

              const SizedBox(height: 20),

              PrimaryButton(
                text: isLoading ? "Loading..." : "Kirim Tautan",
                onPressed: () { handleForgotPassword(); }
              ),
            ],
          ),
        ),
      ),
    );
  }
}