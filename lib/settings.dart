import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindcare/secondpage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "SETTINGS",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSettingsTile("Privacy & Policy"),
          _buildSettingsTile("Terms & Conditions"),
          _buildSettingsTile("Rate & Review"),
          SwitchListTile(
            title: const Text("Switch to Dark-Mode"),
            value: isDarkMode,
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.blue,
            onChanged: (bool value) {
              setState(() {
                isDarkMode = value;
              });
            },
          ),
          _buildSettingsTile("Log-Out", isLogout: true),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, {bool isLogout = false}) {
    return ListTile(
      title: Text(title),
      onTap: () async {
        if (isLogout) {
          bool? confirm = await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Log Out"),
                    ),
                  ],
                ),
          );

          if (confirm == true) {
            // Sign out from Firebase
            await FirebaseAuth.instance.signOut();

            // Navigate to StartPage after logout
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Secondpage()),
            );
          }
        } else {
          // Handle other settings navigation here
        }
      },
    );
  }
}
