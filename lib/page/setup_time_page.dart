import 'package:flutter/material.dart';

import 'countdown_page.dart';

class SetupTimePage extends StatelessWidget {
  const SetupTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speaker Countdown'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const Text(
            'What time should the talk stop?',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
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
          ),
          const Spacer(),
          Text(
            "Made by billyandco",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
