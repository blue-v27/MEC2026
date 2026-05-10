import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> items;

  const HomeScreen({
    super.key,
    required this.items,
  });

  int get totalCalories {
    return items.fold(
      0,
      (sum, item) =>
          sum + (int.tryParse(item["cal"] ?? "0") ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Calories",
            style: TextStyle(fontSize: 20),
          ),

          const SizedBox(height: 10),

          Text(
            totalCalories.toString(),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Hungry",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}