import 'package:flutter/material.dart';
import 'dart:math'; // Imported to generate random numbers for the demo.
import 'package:google_fonts/google_fonts.dart';
// 1. The main widget is now a StatefulWidget.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// 2. The State class holds all the mutable data and the UI logic.
class _HomePageState extends State<HomePage> {
  // --- STATE VARIABLES ---
  // These variables hold the data that can change over time.
  int _heartRate = 55;
  int _sleepQuality = 72;
  int _stresslevel = 45;
  final Random _random = Random();

  // --- STATE-CHANGING METHOD ---
  // This method updates the state variables and calls setState().
  void _updateMetrics() {
    // setState() tells Flutter to rebuild the widget tree with the new values.
    setState(() {
      // Generate new random values to simulate a "test" result.
      _heartRate = 50 + _random.nextInt(21); // Random heart rate between 50 and 70
      _sleepQuality = 60 + _random.nextInt(31); // Random sleep quality between 60 and 90
      _stresslevel = 30 + _random.nextInt(41);
    });
  }

  // 3. The build method and all UI helper methods are now inside the State class.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildMetricsGrid(), // Uses the state variables _heartRate and _sleepQuality
                    const SizedBox(height: 24),
                    _buildHistoricalTrendCard(),
                    const SizedBox(height: 24),
                    _buildTodaysInsightCard(),
                    const SizedBox(height: 32),
                    // _buildTakeTestButton(), // Triggers the _updateMetrics method
                  ],
                ),
              ),
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  /// Builds the header with "Good Morning, XYZ" and a profile icon
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.openSans(
              fontSize: 28,
              color: Colors.black87,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Good Morning,\n',
                style: GoogleFonts.openSans(color: Colors.grey[700], fontWeight: FontWeight.normal),
              ),
              TextSpan(
                text: 'XYZ',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, height: 1.3),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            // color: Colors.black,
            shape: BoxShape.circle,
            // boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
          ),
          child: const Icon(Icons.person_outline, size: 28, color: Colors.black),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Historical Trend (Sensors)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 120, child: CustomPaint(painter: _GraphPainter())),
          const SizedBox(height: 8),
          const Text('Day', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Insight",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          const SizedBox(height: 16),
          const Text('Sleep Pattern', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          const SizedBox(height: 4),
          Text('Your sleep pattern is good.', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 16),
          const Text('Recommendation', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          const SizedBox(height: 4),
          Text('Maintain a consistent sleep schedule.', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 16),
          const Text('Activity Recommendation', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          const SizedBox(height: 4),
          Text('Based on your current metrics, we recommend light physical activity to boost your mood and energy.', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }

  /// Builds the "Take Test" button which now triggers a state change
  // Widget _buildTakeTestButton() {
  //   return Center(
  //     child: ElevatedButton(
  //       onPressed: _updateMetrics, // Calls the method to update the state
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.teal[400],
  //         shape: const StadiumBorder(),
  //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
  //       ),
  //       child: const Text('Take Test', style: TextStyle(fontSize: 18, color: Colors.white)),
  //     ),
  //   );
  // }

  /// Builds the bottom navigation bar
  /// Builds the bottom navigation bar with Take Test button inside
  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 28),
            onPressed: () {},
          ),
          Transform.translate(
            offset: const Offset(0, -45), // Moves the button 10px upward
            child: ElevatedButton(
              onPressed: _updateMetrics, // Calls your function
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
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.grey, size: 28),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 15)),
              if (iconWidget != null) iconWidget!,
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              if (unit != null) const SizedBox(width: 4),
              if (unit != null) Text(unit!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}