import 'package:flutter/material.dart';

import 'page/setup_time_page.dart';

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
