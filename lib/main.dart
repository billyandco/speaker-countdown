import 'package:flutter/material.dart';

void main() {
  runApp(const SpeakerCountdownApp());
}

class SpeakerCountdownApp extends StatelessWidget {
  const SpeakerCountdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      // home: const SetupTimePage(),
      home: const SetupTimePage(),
    );
  }
}

class SetupTimePage extends StatelessWidget {
  const SetupTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speaker Countdown'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'What time should the talk stop?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time == null || !context.mounted) {
                  return;
                }

                final now = DateTime.now();
                final endDate = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  time.hour,
                  time.minute,
                );

                if (context.mounted) {
                  final end = endDate.isBefore(now)
                      ? endDate.add(const Duration(days: 1))
                      : endDate;
                  Navigator.of(context).push(CountdownPage.page(end: end));
                }
              },
              child: const Text('Select time'),
            ),
          ],
        ),
      ),
    );
  }
}

class CountdownPage extends StatelessWidget {
  const CountdownPage({super.key, required this.end});

  final DateTime end;

  static MaterialPageRoute page({required DateTime end}) =>
      MaterialPageRoute(builder: ((context) => CountdownPage(end: end)));

  Stream<String> _countdownStream(DateTime end) async* {
    while (true) {
      final now = DateTime.now();
      final diff = end.difference(now);
      yield _printDuration(diff);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final newEnd = end.add(const Duration(minutes: 5));
              Navigator.of(context).push(CountdownPage.page(end: newEnd));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: FittedBox(
            child: StreamBuilder(
              stream: _countdownStream(end),
              builder: (context, snapshot) {
                if (snapshot.data?.startsWith('-') == true) {
                  return Text(
                    snapshot.data ?? '00:00:00',
                    style: const TextStyle(color: Colors.redAccent),
                  );
                }

                return Text(snapshot.data ?? '00:00:00');
              },
            ),
          ),
        ),
      ),
    );
  }
}
