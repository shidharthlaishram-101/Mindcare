import 'package:flutter/material.dart';
import 'package:mindcare/login.dart';
import 'package:mindcare/registration.dart';

class Secondpage extends StatelessWidget {
  const Secondpage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive layout
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Spacer to push content down a bit from the top
              SizedBox(height: screenHeight * 0.1),

              // Logo Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4A90E2), // A nice shade of blue
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),

              // App Name
              const Text(
                'MINDCARE',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 10),

              // Slogan
              Text(
                'Asses your mental health',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),

              // Flexible spacer to push buttons to the bottom
              const Spacer(),

              // Sign Up Button
              SizedBox(
                width: screenWidth * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3C74FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    // Navigate to the Registration Page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage()));
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Log In Button
              SizedBox(
                width: screenWidth * 0.8,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to the Login Page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF000000),
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Spacer at the bottom
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
