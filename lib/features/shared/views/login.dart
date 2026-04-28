import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../views/register.dart';
import '../views/lupa_password.dart';
import '../../../../core/theme/warna_utama.dart';
import '../widgets/text_field.dart';
import '../widgets/button.dart';
import '../../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    setState(() => isLoading = true);

    var res = await AuthService.login(
      emailController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (res['success']) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login berhasil")));

      // TODO: pindah ke halaman home
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res['message'] ?? "Login gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      appBar: AppBar(
        backgroundColor: WarnaUtama.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Nurtura",
          style: TextStyle(
            fontFamily: 'Gloock',
            fontSize: 20,
            letterSpacing: -0.3,
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
                  "Selamat Datang Kembali",
                  style: TextStyle(
                    fontFamily: 'Gloock',
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: WarnaUtama.text1,
                  ),
                ),

                Text(
                  "Senang melihatmu lagi! Masuk untuk melanjutkan perjalananmu dengan Nurtura.",
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

                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                      text: "Lupa Password?",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: WarnaUtama.text1,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LupaPassword(),
                            ),
                          );
                        },
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                PrimaryButton(
                  text: isLoading ? "Loading..." : "Masuk",
                  onPressed: () {
                    if (!isLoading) handleLogin();
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(child: Divider(color: WarnaUtama.primary)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: WarnaUtama.primary,
                      ),
                    ),
                    Expanded(child: Divider(color: WarnaUtama.primary)),
                  ],
                ),

                const SizedBox(height: 20),

                RichText(
                  text: TextSpan(
                    text: "Belum punya akun? ",
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      color: WarnaUtama.text1.withOpacity(0.7),
                    ),
                    children: [
                      TextSpan(
                        text: "Daftar di sini",
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          color: WarnaUtama.primary,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
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
