import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../views/login.dart';
import '../../../../core/theme/warna_utama.dart';
import '../widgets/button.dart';
import '../../../services/auth_service.dart';

class PeriksaEmail extends StatefulWidget {
  final String email;

  const PeriksaEmail({super.key, required this.email});

  @override
  State<PeriksaEmail> createState() => _PeriksaEmailState();
}

class _PeriksaEmailState extends State<PeriksaEmail> {
  bool isLoading = false;

  Future<void> openEmailApp() async {
    // Real world approach: langsung pakai intent mailto + fallback webmail
    final Uri mailUri = Uri(
      scheme: 'mailto',
      query: Uri.encodeFull(''), // tidak pakai recipient biar universal
    );

    try {
      final canOpen = await canLaunchUrl(mailUri);

      if (canOpen) {
        await launchUrl(
          mailUri,
          mode: LaunchMode.externalApplication,
        );
        return;
      }

      // fallback 1: Gmail web
      await launchUrl(
        Uri.parse("https://mail.google.com"),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // fallback terakhir
      await launchUrl(
        Uri.parse("https://mail.google.com"),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> resendEmail() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    final result = await AuthService.forgotPassword(widget.email);

    if (!mounted) return;

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result["success"]
              ? "Link berhasil dikirim ulang"
              : result["message"] ?? "Gagal kirim ulang",
        ),
      ),
    );
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 192,
                height: 144,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: WarnaUtama.primary, width: 2),
                  color: WarnaUtama.text2.withOpacity(0.5),
                ),
                child: Icon(
                  Icons.email,
                  size: 40,
                  color: WarnaUtama.primary,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Periksa Email Anda",
                style: TextStyle(
                  fontFamily: 'Gloock',
                  fontSize: 28,
                  color: WarnaUtama.text1,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Kami telah mengirimkan tautan ke ${widget.email}.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: WarnaUtama.text1.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 20),

              PrimaryButton(
                icon: Icons.email,
                text: "Buka Aplikasi Email",
                onPressed: openEmailApp,
              ),

              const SizedBox(height: 20),

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
                      text: isLoading ? "Mengirim..." : "Kirim ulang tautan",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        color: WarnaUtama.secondary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = isLoading ? null : resendEmail,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: Text(
                  "Kembali ke halaman login",
                  style: TextStyle(
                    color: WarnaUtama.text1.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}