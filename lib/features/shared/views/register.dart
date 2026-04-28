import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../views/login.dart';
import '../../../../core/theme/warna_utama.dart';
import '../widgets/text_field.dart';
import '../widgets/button.dart';
import '../widgets/pilih_role.dart';
import '../../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedRole = "Ibu";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // VALIDASI
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field harus diisi")));
      return;
    }

    if (!email.contains("@") || !email.contains(".")) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email tidak valid")));
      return;
    }

    if (isLoading) return;

    setState(() => isLoading = true);

    final res = await AuthService.register(
      name,
      email,
      password,
      selectedRole.toLowerCase(),
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    print("REGISTER RESULT: $res");

    if (res['success'] == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Register berhasil")));

      // kasih jeda biar tidak kasar
      await Future.delayed(const Duration(milliseconds: 800));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? "Register gagal")),
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
              MaterialPageRoute(builder: (_) => const LoginPage()),
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: WarnaUtama.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Bergabung dengan Nurtura",
                  style: TextStyle(
                    fontFamily: 'Gloock',
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: WarnaUtama.text1,
                  ),
                ),

                Text(
                  "Mulailah perjalananmu untuk pulih dan merasa lebih baik lagi.",
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
                    "Pilih Role Anda",
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: WarnaUtama.text1,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                PilihRole(
                  selectedRole: selectedRole,
                  onSelected: (role) {
                    setState(() {
                      selectedRole = role;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // NAMA
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nama Lengkap",
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
                  hint: "Nama Lengkap",
                  icon: Icons.person,
                  controller: nameController,
                ),

                const SizedBox(height: 12),

                // EMAIL
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
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

                const SizedBox(height: 12),

                // PASSWORD
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Kata Sandi",
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
                  hint: "......",
                  obscure: true,
                  icon: Icons.lock,
                  controller: passwordController,
                ),

                const SizedBox(height: 20),

                PrimaryButton(
                  text: isLoading ? "Loading..." : "Buat Akun",
                  onPressed: () {
                    if (!isLoading) handleRegister();
                  },
                ),

                const SizedBox(height: 20),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: WarnaUtama.text1.withOpacity(0.6),
                    ),
                    children: [
                      const TextSpan(text: "Sudah punya akun? "),
                      TextSpan(
                        text: "Masuk",
                        style: TextStyle(
                          color: WarnaUtama.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
