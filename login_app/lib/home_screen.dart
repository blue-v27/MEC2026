import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double calorieGoal;

  final int steps;
  final double caloriesPerStep;

  const HomeScreen({
    super.key,
    required this.items,
    required this.calorieGoal,
    required this.steps,
    this.caloriesPerStep = 0.04,
  });

  double get totalCalories {
    return items.fold(
      0,
      (sum, item) => sum + double.parse(item['cal'].toString()),
    );
  }

  double get burnedCalories => steps * caloriesPerStep;

  double get netCalories => totalCalories - burnedCalories;

  double get percent {
    if (calorieGoal == 0) return 0;
    return (netCalories / calorieGoal) * 100;
  }

  String get statusMessage {
    if (percent < 10) {
      return "Famished";
    } else if (percent < 25) {
      return "Hungry";
    } else if (percent < 40) {
      return "Feeling it";
    } else if (percent < 60) {
      return "Energized";
    } else if (percent < 85) {
      return "Perfect";
    } else if (percent <= 105) {
      return "Full";
    } else {
      return "Lethargic";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Calories',
            style: TextStyle(fontSize: 20),
          ),

          const SizedBox(height: 10),

          Text(
            totalCalories.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '${percent.toStringAsFixed(0)}% of goal',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          // STEPS SECTION
          Text(
            "Steps: $steps",
            style: const TextStyle(fontSize: 18),
          ),

          Text(
            "Burned: ${burnedCalories.toStringAsFixed(0)} kcal",
          ),

          Text(
            "Net: ${netCalories.toStringAsFixed(0)} kcal",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 40),

          const Text(
            '🐯',
            style: TextStyle(fontSize: 120),
          ),

          const SizedBox(height: 20),

          Text(
            statusMessage,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}