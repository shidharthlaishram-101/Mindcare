import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// Firebase Core and Auth are required for Firebase services
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Google Sign-In package is needed for Google authentication
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindcare/home.dart';
import 'package:mindcare/login.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Controllers to manage user input for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State variables for UI logic
  bool _isPasswordVisible = false;
  bool _agreeToTerms = false;
  bool _isLoading =
      false; // To show a loading indicator during async operations

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- FIREBASE AUTHENTICATION LOGIC ---

  // Function to handle email & password registration
  Future<void> _createAccountWithEmailAndPassword() async {
    // Validate Terms Agreement
    if (!_agreeToTerms) {
      _showErrorSnackBar("Please agree to the Terms & Policy to continue.");
      return;
    }

    // Input Validation (Pre-checks)
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty) {
      _showErrorSnackBar("Please enter your name.");
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showErrorSnackBar("Please enter a valid email address.");
      return;
    }
    if (password.length < 6) {
      _showErrorSnackBar("Password must be at least 6 characters long.");
      return;
    }

    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    try {
      // Create user with Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        // Update display name
        await user.updateDisplayName(name);
        await user.reload();

        // Save user info in Firestore
        await _firestore.collection("Users").doc(user.uid).set({
          "uid": user.uid,
          "name": name,
          "email": user.email,
          "createdAt": FieldValue.serverTimestamp(),
          "signInMethod": "email_password",
        });

        // Navigate to HomePage
        _navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      // Firebase-specific error handling
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      _showErrorSnackBar(message);
    } catch (e) {
      // General error handling
      _showErrorSnackBar('An unexpected error occurred.');
    } finally {
      // Reset loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Sign up with Google
  Future<void> signUpWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      // Initialize the GoogleSignIn instance (v7.2.0)
      await _googleSignIn.initialize(
        clientId:
            '196820978897-05usfqpl4oaqv5pgg476ku46v8lm2q0k.apps.googleusercontent.com',
        serverClientId:
            '196820978897-vtliblh35qhc32fqal88fci5cuo1tq0s.apps.googleusercontent.com',
      );

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate();

      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // User canceled
      }

      // Get Google authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential with only idToken
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        final userDoc = _firestore
            .collection("Users")
            .doc(userCredential.user!.uid);

        // Check if the user already exists
        if ((await userDoc.get()).exists) {
          _showErrorSnackBar("This account already exists. Please sign in.");
          await FirebaseAuth.instance.signOut(); // optional: sign them out
          return;
        }

        // New user → save info in Firestore
        await userDoc.set({
          "uid": userCredential.user!.uid,
          "email": userCredential.user!.email,
          "createdAt": FieldValue.serverTimestamp(),
          "signInMethod": "google",
        });
      }

      _navigateToHome();
    } catch (e) {
      _showErrorSnackBar("Google Sign-Up failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- NAVIGATION AND UI HELPERS ---
  void _navigateToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
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
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                label: 'Name',
                hint: 'Enter your name',
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildTermsAndPolicyCheckbox(),
              const SizedBox(height: 20),
              _buildCreateAccountButton(),
              const SizedBox(height: 30),
              _buildDivider(),
              const SizedBox(height: 30),
              _buildSocialButton(
                icon: 'assets/images/google.png',
                label: 'Sign up with Google',
                onPressed: signUpWithGoogle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
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
          controller: controller, // Link the controller to the text field
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
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
          controller:
              _passwordController, // Link the controller to the password field
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: '8 - 12 characters',
            hintStyle: const TextStyle(color: Colors.black38),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
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

  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            (_agreeToTerms && !_isLoading)
                ? _createAccountWithEmailAndPassword
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _agreeToTerms ? const Color(0xFF3C74FF) : Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child:
            _isLoading
                ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                : Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _agreeToTerms ? Colors.white : Colors.black54,
                  ),
                ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.black26)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'or',
            style: TextStyle(color: Colors.black45, fontSize: 16),
          ),
        ),
        Expanded(child: Divider(color: Colors.black26)),
      ],
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: (_agreeToTerms && !_isLoading) ? onPressed : null,
        // _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: _agreeToTerms ? Colors.white : Colors.grey.shade300,
        ),
        icon: Image.asset(
          icon,
          height: 24.0,
          width: 24.0,
          color: _agreeToTerms ? null : Colors.white,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _agreeToTerms ? Colors.black87 : Colors.black54,
          ),
        ),
      ),
    );
  }

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
                ),
                const TextSpan(text: ' & '),
                TextSpan(
                  text: 'Policy',
                  style: const TextStyle(
                    color: Color(0xFF3C80FF),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
