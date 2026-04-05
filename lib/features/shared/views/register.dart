import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../views/login.dart';
import '../../../../core/theme/warna_utama.dart';
import '../widgets/text_field.dart';
import '../widgets/button.dart';
import '../widgets/pilih_role.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedRole = "Ibu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      appBar: AppBar(
        backgroundColor: WarnaUtama.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: WarnaUtama.text1,
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
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
                "Bergabung dengan Nurtura",
                style: TextStyle(
                  fontFamily: 'Gloock',
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: WarnaUtama.text1
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

              SizedBox(height: 20),

              Align(alignment: AlignmentGeometry.centerLeft,
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
              SizedBox(height: 5),
              PilihRole(
                selectedRole: selectedRole,
                onSelected: (role) {
                  setState(() {
                    selectedRole = role;
                  });
                },
              ),
              SizedBox(height: 20),

              // Form
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
              SizedBox(height: 5),
              CustomTextField(hint: "Nama Lengkap", icon: Icons.person),
              SizedBox(height: 12),

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

              PrimaryButton(
                text: "Buat Akun",
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
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    color: WarnaUtama.text1.withOpacity(0.6),
                  ),
                  children: [
                    TextSpan(text: "Sudah punya akun? "),
                    TextSpan(
                      text: "Masuk",
                      style: TextStyle(
                        color: WarnaUtama.kotakLogin,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: WarnaUtama.primary,
                        decorationThickness: 1.5,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
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
