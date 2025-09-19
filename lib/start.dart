import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindcare/login.dart';
// import 'package:mindcare/registration.dart';
// import 'package:mindcare/home.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C2FF), // light blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Title
            Text(
              "M I N D C A R E",
              style: GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "your mental health\nassistant",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(fontSize: 14, color: Colors.black54),
            ),
            // GIF instead of static image
            Image.asset(
              "assets/video/home_screen.gif",
              height: 400,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
