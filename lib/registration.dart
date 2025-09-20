import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mindcare/home.dart';

import 'login.dart';
// RegistrationPage widget builds the main screen UI.
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // State variable to toggle password visibility
  bool _isPasswordVisible = false;
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Using SingleChildScrollView to prevent overflow on smaller screens
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Sign up" Title
              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),

              // "Already have an account?" Text
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontFamily: 'Inter',
                  ),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Sign in',
                      style: const TextStyle(
                        color: Color(0xFF3C80FF),
                        fontWeight: FontWeight.bold,
                      ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Name Input Field
              _buildTextField(label: 'Name', hint: 'Enter your name'),
              const SizedBox(height: 20),

              // Email Input Field
              _buildTextField(label: 'Email', hint: 'Enter your email'),
              const SizedBox(height: 20),

              // Password Input Field
              _buildPasswordField(),
              const SizedBox(height: 20),

              // Checkbox widget
              _buildTermsAndPolicyCheckbox(),
              const SizedBox(height: 20),

              // "Create Account" Button
              _buildCreateAccountButton(),
              const SizedBox(height: 30),

              // "or" Divider
              _buildDivider(),
              const SizedBox(height: 30),

              // Social Sign-up Buttons
              _buildSocialButton(
                icon: 'assets/images/google.png', // Placeholder, replace with actual asset
                label: 'Sign up with Google',
                // iconWidget: _buildGoogleIcon(),
              ),
              // const SizedBox(height: 16),
              // _buildSocialButton(
              //   icon: 'assets/apple.png', // Placeholder, replace with actual asset
              //   label: 'Sign up with Apple',
              //   iconWidget: const Icon(Icons.apple, color: Colors.black),
              // ),
              // const SizedBox(height: 16),
              // _buildSocialButton(
              //   icon: 'assets/facebook.png', // Placeholder, replace with actual asset
              //   label: 'Sign up with Facebook',
              //   iconWidget: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build standard text input fields
  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xFF3C74FF)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  // Helper widget to build the password field with a visibility toggle
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: '8 - 12 characters',
            hintStyle: const TextStyle(color: Colors.black38),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xFF3C74FF)),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                // Toggles the password visibility
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for the main action button
  // Helper widget for the main action button
  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        // Use the _agreeToTerms variable to control the button's state
        onPressed: _agreeToTerms
            ? () {
          Navigator.push
            (context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // from right to left
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: FadeTransition(
                        opacity: animation.drive(fadeTween),
                        child: child,
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 800)));
          // TODO: Implement account creation logic
        }
            : null, // Button is disabled if terms are not agreed to
        style: ElevatedButton.styleFrom(
          // Change background color based on whether terms are agreed to
          backgroundColor:
          _agreeToTerms ? const Color(0xFF3C74FF) : Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          'Create Account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            // Change text color for better contrast
            color: _agreeToTerms ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  // Helper widget for the "or" divider
  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.black26)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'or',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.black26)),
      ],
    );
  }

  // Helper widget for social media sign-up buttons
  Widget _buildSocialButton({
    required String icon,
    required String label,
    Widget? iconWidget,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: Implement social sign-up logic
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.white,
        ),
        icon: iconWidget ??
            Image.asset(
              icon,
              height: 24.0,
              width: 24.0,
            ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // Add this new helper method anywhere inside your _RegistrationPageState class

  // Helper widget for the Terms & Policy checkbox
  Widget _buildTermsAndPolicyCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (bool? value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
          activeColor: const Color(0xFF3C74FF),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'Inter',
              ),
              children: [
                const TextSpan(text: 'I agree with the '),
                TextSpan(
                  text: 'Terms',
                  style: const TextStyle(
                    color: Color(0xFF3C80FF),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  // recognizer: TapGestureRecognizer()..onTap = () {
                  //   // TODO: Navigate to Terms page
                  //   print('Terms tapped!');
                  // },
                ),
                const TextSpan(text: ' & '),
                TextSpan(
                  text: 'Policy',
                  style: const TextStyle(
                    color: Color(0xFF3C80FF),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  // recognizer: TapGestureRecognizer()..onTap = () {
                  //   // TODO: Navigate to Policy page
                  //   print('Policy tapped!');
                  // },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  // A custom widget for the Google icon to match the design
//   Widget _buildGoogleIcon() {
//     return Image.network(
//       'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
//       height: 22,
//       width: 22,
//     );
//   }
}
