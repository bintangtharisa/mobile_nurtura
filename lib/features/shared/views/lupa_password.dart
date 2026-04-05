import 'package:flutter/material.dart';
import '../views/login.dart';
import '../../../../core/theme/warna_utama.dart';
import '../widgets/text_field.dart';
import '../widgets/button.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
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
                Center(
                  child: Container(
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
                ),

              SizedBox(height: 20),

              Text(
                "Lupa Kata Sandi?",
                style: TextStyle(
                  fontFamily: 'Gloock',
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: WarnaUtama.text1
                ),
              ),

              SizedBox(height: 10),

              Text(
                "Masukkan email terdaftar Anda dan kami akan mengirimkan tautan pengaturan ulang kata sandi ke kotak masuk Anda.",
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
                  "Alamat Email",
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
              SizedBox(height: 20),
              PrimaryButton(
                text: "Kirim Tautan",
                onPressed: () {
                  // Logika untuk mengirim tautan reset password
                },
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}