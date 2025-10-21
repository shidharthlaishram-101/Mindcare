import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String firstName = '';
    String lastName = '';
    String email = user.email ?? '';

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        firstName = data['firstName'] ?? firstName;
        lastName = data['lastName'] ?? lastName;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    if (mounted) {
      setState(() {
        _firstNameController.text = firstName;
        _lastNameController.text = lastName;
        _emailController.text = email;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'PROFILE',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.purple.shade400,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField(
              controller: _firstNameController,
              label: 'First Name',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _lastNameController,
              label: 'Last Name',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Optional: Add save/edit functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: false, // Keeps it non-tappable
          keyboardType: keyboardType,
          // 1. Set the text style to prevent it from turning grey
          style: const TextStyle(color: Colors.black), // <-- ADD THIS
          decoration: InputDecoration(
            // 2. Define the border style for the disabled state
            disabledBorder: OutlineInputBorder(
              // <-- CONFIGURE THIS
              borderRadius: BorderRadius.circular(10),
              // Use the same color as your normal border
              borderSide: const BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
          ),
        ),
      ],
    );
  }
}
