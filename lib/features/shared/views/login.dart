import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../views/register.dart';
import '../views/lupa_password.dart';
import '../../../../core/theme/warna_utama.dart';
import '../widgets/text_field.dart';
import '../widgets/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selectedRole = "Ibu";
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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Top Card
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: WarnaUtama.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Selamat Datang Kembali",
                style: TextStyle(
                  fontFamily: 'Gloock',
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: WarnaUtama.text1
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
              SizedBox(height: 20),

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
              SizedBox(height: 5),
              CustomTextField(hint: "nama@gmail.com", icon: Icons.email),
              SizedBox(height: 12),

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
              SizedBox(height: 5),
              CustomTextField(hint: "......", obscure: true, icon: Icons.lock),

              SizedBox(height: 20),
              
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
                  
              SizedBox(height: 15),

              PrimaryButton(
                text: "Masuk",
                onPressed: () {},
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: WarnaUtama.primary,
                      thickness: 1,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: WarnaUtama.primary,
                    ),
                  ),

                  Expanded(
                    child: Divider(
                      color: WarnaUtama.primary,
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

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
                          decorationColor: WarnaUtama.primary,
                          decorationThickness: 1.5,
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