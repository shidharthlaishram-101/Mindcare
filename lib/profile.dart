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
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender;
  int? _age;

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String firstName = '';
    String lastName = '';
    String email = user.email ?? '';
    int? age;
    String? gender;

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
        age =
            (data['age'] is int)
                ? data['age']
                : int.tryParse(data['age']?.toString() ?? '');
        gender = data['gender'] ?? gender;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    if (mounted) {
      setState(() {
        _firstNameController.text = firstName;
        _lastNameController.text = lastName;
        _emailController.text = email;
        _age = age;
        _ageController.text = age?.toString() ?? '';
        _selectedGender = gender;
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
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // set to false to disable back navigation
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            'PROFILE',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
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
              const SizedBox(height: 20),
              _buildTextField(
                controller: _ageController,
                label: 'Age',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _buildGenderField(
                label: 'Gender',
                value: _selectedGender ?? 'N/A',
              ),
              // const SizedBox(height: 40),
              // ElevatedButton(
              //   onPressed: () {
              //     // TODO: Add edit/save functionality
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.grey.shade300,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 50,
              //       vertical: 15,
              //     ),
              //   ),
              //   child: Text(
              //     'Edit Profile',
              //     style: TextStyle(
              //       color: Colors.grey.shade700,
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
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
          enabled: false,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
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

  Widget _buildGenderField({required String label, required String value}) {
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
