import 'package:flutter/material.dart';
import 'food_service.dart';

class LogScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const LogScreen({
    super.key,
    required this.items,
  });

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  List<dynamic> searchResults = [];
  bool isLoading = false;

  // SEARCH FOOD
  Future<void> searchFood() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final results = await FoodService.searchFood(
        _searchController.text,
      );

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  // ADD FOOD FROM API
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
            double.tryParse(
              nutrient['value'].toString(),
            ) ??
            0;

        if (name.contains('Energy')) {
          calories = value;
        }

        if (name.contains('Protein')) {
          protein = value;
        }

        if (name.contains('Carbohydrate')) {
          carbs = value;
        }

        if (name.contains('Total lipid')) {
          fat = value;
        }
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${food['description']} added',
        ),
      ),
    );
  }

  // CREATE CUSTOM FOOD
  void showCreateDialog() {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Food'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Food Name',
                  ),
                ),

                TextField(
                  controller: calController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Calories',
                  ),
                ),

                TextField(
                  controller: proteinController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Protein',
                  ),
                ),

                TextField(
                  controller: carbsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Carbs',
                  ),
                ),

                TextField(
                  controller: fatController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Fat',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.items.add({
                    'name': nameController.text,
                    'cal': double.tryParse(
                          calController.text,
                        ) ??
                        0,
                    'protein': double.tryParse(
                          proteinController.text,
                        ) ??
                        0,
                    'carbs': double.tryParse(
                          carbsController.text,
                        ) ??
                        0,
                    'fat': double.tryParse(
                          fatController.text,
                        ) ??
                        0,
                  });
                });

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // BARCODE SCAN PLACEHOLDER
  void scanBarcode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Barcode scanning coming next',
        ),
      ),
    );
  }

  // DELETE FOOD
  void deleteFood(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                label: const Text('Scan'),
              ),

              ElevatedButton.icon(
                onPressed: showCreateDialog,
                icon: const Icon(Icons.add),
                label: const Text('Create'),
              ),
            ],
          ),
        ),

        // SEARCH BAR
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search food...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              ElevatedButton(
                onPressed: searchFood,
                child: const Text('Search'),
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
                return Card(
                  child: ListTile(
                    title: Text(
                      food['description'] ?? 'Unknown',
                    ),
                    subtitle: Text(
                      food['brandOwner']?.toString() ?? '',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => addFood(food),
                    ),
                  ),
                );
              }).toList(),

              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Logged Foods',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // LOGGED FOODS
              ...widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return Card(
                  child: ListTile(
                    title: Text(item['name'].toString()),
                    subtitle: Text(
                      'Calories: ${item['cal']} | '
                      'Protein: ${item['protein']}g | '
                      'Carbs: ${item['carbs']}g | '
                      'Fat: ${item['fat']}g',
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () => deleteFood(index),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}