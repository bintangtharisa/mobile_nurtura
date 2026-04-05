import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../views/login.dart';
import '../../../../core/theme/warna_utama.dart';
import '../widgets/button.dart';

class PeriksaEmail extends StatefulWidget {
  const PeriksaEmail({super.key});

  @override
  State<PeriksaEmail> createState() => _PeriksaEmailState();
}

class _PeriksaEmailState extends State<PeriksaEmail> {
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
                    width: 192,
                    height: 144,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: WarnaUtama.primary,
                        width: 2,
                      ),
                      color: WarnaUtama.text2.withOpacity(0.5),
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 40,
                      color: WarnaUtama.primary,
                    ),
                  ),
                ),

              SizedBox(height: 30),

              Text(
                "Periksa Email Anda",
                style: TextStyle(
                  fontFamily: 'Gloock',
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: WarnaUtama.text1
                ),
              ),

              SizedBox(height: 10),

              Text(
                "Kami telah mengirimkan tautan pengaturan ulang kata sandi ke email Anda. Klik tautan di pesan tersebut untuk mengatur kata sandi baru.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: WarnaUtama.text1.withOpacity(0.7),
                ),
              ),

              SizedBox(height: 20),

              PrimaryButton(
                icon: Icons.email,
                text: "Buka Aplikasi Email",
                onPressed: () {
                  // Logika untuk membuka email di perangkat pengguna
                },
              ),

              SizedBox(height: 20),

              RichText(
                text: TextSpan(
                  text: "Tidak menerima email? ",
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    color: WarnaUtama.text1.withOpacity(0.7),
                  ),
                  children: [
                    TextSpan(
                      text: "Kirim ulang tautan",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: WarnaUtama.secondary,
                        ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Link telah dikirim ulang")),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                      
              SizedBox(height: 15),

              RichText(
                text: TextSpan(
                  text: "Kembali ke halaman utama",
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: WarnaUtama.text1.withOpacity(0.4),
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
              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}