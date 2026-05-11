import 'package:flutter/material.dart';
import 'food_service.dart';

class LogScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int steps;

  const LogScreen({
    super.key,
    required this.items,
    required this.steps,
  });

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  List<dynamic> searchResults = [];
  bool isLoading = false;

  double caloriesPerStep = 0.04;

  double get burnedCalories =>
      widget.steps * caloriesPerStep;

  double get totalCalories {
    return widget.items.fold(
      0,
          (sum, item) =>
      sum + (double.tryParse(item['cal'].toString()) ?? 0),
    );
  }

  double get netCalories =>
      totalCalories - burnedCalories;

  // SEARCH FOOD
  Future<void> searchFood() async {
    if (_searchController.text.isEmpty) return;

    setState(() => isLoading = true);

    final results = await FoodService.searchFood(
      _searchController.text,
    );

    setState(() {
      searchResults = results;
      isLoading = false;
    });
  }

  // ADD FOOD
  void addFood(dynamic food) {
    setState(() {
      widget.items.add({
        'name': food['description'] ?? 'Unknown',
        'cal': 0,
        'protein': 0,
        'carbs': 0,
        'fat': 0,
      });
    });
  }

  // CREATE FOOD
  void showCreateDialog() {
    final nameController = TextEditingController();
    final calController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Food"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),
              TextField(
                controller: calController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Calories",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.items.add({
                    'name': nameController.text,
                    'cal':
                    double.tryParse(calController.text) ?? 0,
                  });
                });

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void deleteFood(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // STEP DISPLAY (FROM MAIN SCREEN)
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text("Steps: ${widget.steps}"),
              Text(
                "Burned: ${burnedCalories.toStringAsFixed(0)} kcal",
              ),
              Text(
                "Net: ${netCalories.toStringAsFixed(0)} kcal",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const Divider(),

        // TOP BUTTONS (UNCHANGED)
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text("Scan"),
              ),
              ElevatedButton.icon(
                onPressed: showCreateDialog,
                icon: const Icon(Icons.add),
                label: const Text("Create"),
              ),
            ],
          ),
        ),

        // SEARCH
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search food...",
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: searchFood,
                child: const Text("Search"),
              ),
            ],
          ),
        ),

        if (isLoading)
          const CircularProgressIndicator(),

        Expanded(
          child: ListView(
            children: [
              ...searchResults.map((food) {
                return ListTile(
                  title: Text(food['description'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => addFood(food),
                  ),
                );
              }),

              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Logged Foods",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ...widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return ListTile(
                  title: Text(item['name'].toString()),
                  subtitle:
                  Text("Calories: ${item['cal']}"),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => deleteFood(index),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}