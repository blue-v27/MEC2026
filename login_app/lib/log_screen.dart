import 'package:flutter/material.dart';

class LogScreen extends StatefulWidget {
  final List<Map<String, String>> items;

  const LogScreen({
    super.key,
    required this.items,
  });

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  // Add item dialog
  void _showAddDialog() {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final qtyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Food"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Food Name",
                ),
              ),
              TextField(
                controller: calController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Calories",
                ),
              ),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantity",
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
                if (nameController.text.isNotEmpty &&
                    calController.text.isNotEmpty &&
                    qtyController.text.isNotEmpty) {
                  setState(() {
                    widget.items.add({
                      "name": nameController.text,
                      "cal": calController.text,
                      "qty": qtyController.text,
                    });
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Delete item
  void _deleteItem(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text("Scan"),
              ),
              ElevatedButton(
                onPressed: _showAddDialog,
                child: const Text("Create"),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Search"),
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: widget.items.isEmpty
              ? const Center(
                  child: Text("No entries yet"),
                )
              : ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        title: Text(widget.items[index]["name"]!),
                        subtitle: Text(
                          "Calories: ${widget.items[index]["cal"]}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Qty: ${widget.items[index]["qty"]}",
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _deleteItem(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}