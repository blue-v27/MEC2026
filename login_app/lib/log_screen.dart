import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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

  // =========================
  // STEPS CALCULATIONS
  // =========================

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

  // =========================
  // SEARCH FOOD
  // =========================

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

  // =========================
  // ADD FOOD (API)
  // =========================

  void addFood(dynamic food) {
    double calories = 0;
    double protein = 0;
    double carbs = 0;
    double fat = 0;

    if (food['foodNutrients'] != null) {
      for (var nutrient in food['foodNutrients']) {
        final name =
            nutrient['nutrientName']?.toString() ?? '';

        final value =
            double.tryParse(nutrient['value'].toString()) ?? 0;

        if (name.contains('Energy')) calories = value;
        if (name.contains('Protein')) protein = value;
        if (name.contains('Carbohydrate')) carbs = value;
        if (name.contains('Total lipid')) fat = value;
      }
    }

    setState(() {
      widget.items.add({
        'name': food['description'] ?? 'Unknown Food',
        'cal': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      });
    });
  }

  // =========================
  // CREATE FOOD (MANUAL)
  // =========================

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

  // =========================
  // CAMERA SCAN
  // =========================

  void scanBarcode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Scan Food")),
          body: MobileScanner(
            onDetect: (capture) async {
              final barcode =
                  capture.barcodes.first.rawValue;

              if (barcode != null) {
                Navigator.pop(context);

                final food =
                await FoodService.searchByBarcode(barcode);

                if (food != null) {
                  addFood(food);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${food['description']} added",
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Food not found"),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  // =========================
  // DELETE FOOD
  // =========================

  void deleteFood(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // STEP PANEL
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const Divider(),

        // TOP BUTTONS
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: scanBarcode,
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
          const Padding(
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator(),
          ),

        Expanded(
          child: ListView(
            children: [
              // SEARCH RESULTS
              ...searchResults.map((food) {
                return ListTile(
                  title:
                  Text(food['description'] ?? ''),
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

              // LOGGED ITEMS
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