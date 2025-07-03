
import 'package:flutter/material.dart';
import 'dart:async';
import 'analog_clock_painter.dart'; // Import the custom painter

class CountdownPage extends StatelessWidget {
  const CountdownPage({super.key, required this.end});

  final DateTime end;

  static MaterialPageRoute page({required DateTime end}) =>
      MaterialPageRoute(builder: ((context) => CountdownPage(end: end)));

  // Stream now yields Duration directly
  Stream<Duration> _countdownDurationStream(DateTime end) async* {
    while (true) {
      final now = DateTime.now();
      final diff = end.difference(now);
      yield diff;
      if (diff.isNegative && diff.abs() > const Duration(hours:12)) { // Stop if too far negative for clock display
          break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // Helper to convert Duration to a DateTime for the clock painter
  // The clock painter expects a DateTime, so we create one that represents
  // the hours, minutes, seconds of the remaining duration.
  DateTime _durationToDateTime(Duration duration) {
    int hours = duration.inHours.abs() % 24; // Clock can only show up to 24 or 12
    int minutes = duration.inMinutes.remainder(60).abs();
    int seconds = duration.inSeconds.remainder(60).abs();
    // Using a fixed date, only time matters for the painter
    return DateTime(2000, 1, 1, hours, minutes, seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Countdown Clock"), // Added a title
        actions: [
          IconButton(
            onPressed: () {
              // When adding time, we create a new page with the new end time.
              // This is how the original code worked.
              final newEnd = end.add(const Duration(minutes: 5));
              Navigator.of(context).pushReplacement(CountdownPage.page(end: newEnd));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<Duration>(
          stream: _countdownDurationStream(end),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator(); // Show loader until first duration
            }

            final duration = snapshot.data!;
            final displayTime = _durationToDateTime(duration);

            // Determine colors based on whether time is negative
            final bool isNegative = duration.isNegative;
            final Color clockHandColor = isNegative ? Colors.grey : Colors.black;
            final Color clockSecondHandColor = isNegative ? Colors.red.shade900 : Colors.redAccent;
            final Color clockDialColor = isNegative ? Colors.black54 : Colors.white;
            final Color clockNumberColor = isNegative ? Colors.grey.shade300 : Colors.black;
            final Color clockTickColor = isNegative ? Colors.grey.shade400 : Colors.grey;


            // Use AspectRatio to make the clock circular
            return AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Add some padding
                child: CustomPaint(
                  painter: AnalogClockPainter(
                    dateTime: displayTime,
                    dialColor: clockDialColor,
                    handColor: clockHandColor,
                    secondHandColor: clockSecondHandColor,
                    numberColor: clockNumberColor,
                    tickColor: clockTickColor,
                  ),
                  child: Container(), // CustomPaint needs a child
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
