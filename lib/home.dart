import 'package:flutter/material.dart';
import 'dart:math'; // Imported to generate random numbers for the demo.
import 'package:google_fonts/google_fonts.dart';
import 'package:mindcare/settings.dart';
import 'profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 1. The main widget is now a StatefulWidget.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// 2. The State class holds all the mutable data and the UI logic.
class _HomePageState extends State<HomePage> {
  // --- USER DATA ---
  String _userName = 'User';
  // --- STATE VARIABLES ---
  // These variables hold the data that can change over time.
  int _heartRate = 55;
  int _sleepQuality = 72;
  int _stresslevel = 45;
  final Random _random = Random();

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    String firstName = 'User'; // Default name

    if (user != null) {
      // Check FirebaseAuth displayName first
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        firstName = user.displayName!.split(' ').first;
      } else {
        // Fetch firstname from Firestore
        try {
          final doc =
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .get();

          if (doc.exists) {
            final data = doc.data();
            if (data != null && data.containsKey('firstname')) {
              final fullName = data['firstName'] as String;
              if (fullName.isNotEmpty) {
                firstName = fullName.split(' ').first;
              }
            }
          }
        } catch (e) {
          print('Error fetching user data: $e');
        }
      }

      // Update state once
      if (mounted) {
        setState(() {
          _userName = firstName;
        });
      }
    }
  }

  // --- STATE-CHANGING METHOD ---
  // This method updates the state variables and calls setState().
  void _updateMetrics() {
    // setState() tells Flutter to rebuild the widget tree with the new values.
    setState(() {
      // Generate new random values to simulate a "test" result.
      _heartRate =
          50 + _random.nextInt(21); // Random heart rate between 50 and 70
      _sleepQuality =
          60 + _random.nextInt(31); // Random sleep quality between 60 and 90
      _stresslevel = 30 + _random.nextInt(41);
    });
  }

  // 3. The build method and all UI helper methods are now inside the State class.
  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the widget is initialized.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Allows the body to extend behind the floating action button,
      // which is key for the transparent/floating effect.
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        // Set bottom to false to allow the scroll view to go behind the button.
        bottom: false,
        child: SingleChildScrollView(
          // Add padding to the bottom so the last item isn't hidden by the button.
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMetricsGrid(),
              const SizedBox(height: 24),
              _buildHistoricalTrendCard(),
              const SizedBox(height: 24),
              _buildTodaysInsightCard(),
              // The button is no longer needed here.
            ],
          ),
        ),
      ),
      // Use the dedicated property for a floating button.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: _updateMetrics,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal[400],
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
        ),
        child: const Text(
          'Take Test',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  // You can now safely delete the `_buildTakeTestButton` method
  // as its logic is handled by the `floatingActionButton` above.

  /// Builds the header with "Good Morning, XYZ" and a profile icon
  Widget _buildHeader() {
    // Pass BuildContext to the method
    String getgreeting() {
      final hour = DateTime.now().hour;
      if (hour >= 5 && hour < 12) {
        return 'Good Morning,';
      } else if (hour >= 12 && hour < 17) {
        return 'Good Afternoon,';
      } else {
        return 'Good Evening,';
      }
    }

    final String greeting = getgreeting();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.openSans(fontSize: 28, color: Colors.black87),
            children: <TextSpan>[
              TextSpan(
                text: '$greeting\n',
                style: GoogleFonts.openSans(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: _userName,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        // The Container now has a Row as its single child
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(shape: BoxShape.circle),
          // This Row holds the two IconButtons
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.person_outline,
                  size: 28,
                  color: Colors.black,
                ),
                onPressed: () {
                  // This is where the navigation logic goes
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  size: 28,
                  color: Colors.black,
                ),
                onPressed: () {
                  // This is where the navigation logic goes
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the grid of metric cards using the current state values
  Widget _buildMetricsGrid() {
    return SizedBox(
      height: 160, // fixed card height
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: 200,
            child: _MetricCard(
              title: 'Heart Rate',
              value: _heartRate.toString(),
              unit: 'bpm',
              iconWidget: Row(
                children: [
                  // Icon(Icons.show_chart, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 2),
                  Icon(Icons.favorite, color: Colors.red[400], size: 20),
                ],
              ),
              progress: _heartRate / 100.0,
              progressColor: Colors.red[400]!,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 200,
            child: _MetricCard(
              title: 'Sleep Quality',
              value: '$_sleepQuality%',
              iconWidget: Row(
                children: [
                  const SizedBox(width: 2),
                  Icon(Icons.bed, color: Colors.blueAccent, size: 20),
                ],
              ),
              progress: _sleepQuality / 100.0,
              progressColor: Colors.blueAccent,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 200,
            child: _MetricCard(
              title: 'Stress Level',
              value: '$_stresslevel%',
              progress: _stresslevel / 100.0,
              iconWidget: Row(
                children: [
                  const SizedBox(width: 2),
                  Icon(Icons.mood_rounded, color: Colors.deepOrange, size: 20),
                ],
              ),
              progressColor: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the historical trend card
  Widget _buildHistoricalTrendCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Historical Trend (Sensors)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 120, child: CustomPaint(painter: _GraphPainter())),
          const SizedBox(height: 8),
          const Text(
            'Day',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Builds the "Today's Insight" card
  Widget _buildTodaysInsightCard() {
    return Container(
      padding: const EdgeInsets.all(55),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Insight",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sleep Pattern',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            'Your sleep pattern is good.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recommendation',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            'Maintain a consistent sleep schedule.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text(
            'Activity Recommendation',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            'Based on your current metrics, we recommend light physical activity to boost your mood and energy.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Builds the "Take Test" button which now triggers a state change
  // Widget _buildTakeTestButton() {
  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: Padding(
  //       padding: const EdgeInsets.only(bottom: 30),
  //       child: Container(
  //         color: Colors.transparent, // makes parent container transparent
  //         child: ElevatedButton(
  //           onPressed: _updateMetrics,
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.teal[400], // button color
  //             elevation: 0, // removes shadow for cleaner transparency
  //             shape: const StadiumBorder(),
  //             padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
  //           ),
  //           child: const Text(
  //             'Take Test',
  //             style: TextStyle(fontSize: 18, color: Colors.white),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  /// Builds the bottom navigation bar with Take Test button inside
  // Widget _buildBottomNavBar() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  //     // decoration: const BoxDecoration(
  //     //   color: Colors.transparent, // truly transparent now
  //     // ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         Transform.translate(
  //           offset: const Offset(0, -45),
  //           child: ElevatedButton(
  //             onPressed: _updateMetrics,
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.teal[400],
  //               shape: const StadiumBorder(),
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 55,
  //                 vertical: 20,
  //               ),
  //             ),
  //             child: const Text(
  //               'Take Test',
  //               style: TextStyle(fontSize: 18, color: Colors.white),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

// These helper widgets do not need to be stateful themselves.
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final Widget? iconWidget;
  final double progress;
  final Color progressColor;

  const _MetricCard({
    required this.title,
    required this.value,
    this.unit,
    this.iconWidget,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[700], fontSize: 15),
              ),
              if (iconWidget != null) iconWidget!,
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit != null) const SizedBox(width: 4),
              if (unit != null)
                Text(
                  unit!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey[300]!
          ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
