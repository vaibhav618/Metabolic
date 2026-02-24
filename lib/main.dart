import 'package:flutter/material.dart';
// import 'package:metabolic/features/food_preference/food_preferences.dart';
import 'package:metabolic/features/result_process/screens/metabolic_result_process.dart';
// import 'package:metabolic/features/result_process/screens/metabolic_result_process.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Change the score here to see the colors change:
      // 65.0 -> Red (Severe)
      // 75.0 -> Yellow (Moderate)
      // 88.0 -> Green (Good)
      home: MetabolismResultProcess(score: 82),
    );
  }
}
