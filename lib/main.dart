import 'package:flutter/material.dart';
import 'screens/test_ai_screen.dart';

void main() {
  runApp(const ManuScanApp());
}

class ManuScanApp extends StatelessWidget {
  const ManuScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestAiScreen(),
    );
  }
}