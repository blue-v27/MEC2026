import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'log_screen.dart';
import 'friends_screen.dart';
import 'package:pedometer/pedometer.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainScreen(),
  ));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  // Global State
  String name = "User";
  double weight = 70.0;
  double height = 175.0;
  double activityLevel = 3.0;
  double calorieGoal = 3000;
  int steps = 0;

  Stream<StepCount>? _stepStream;

  @override
  void initState() {
    super.initState();
    _stepStream = Pedometer.stepCountStream;
    _stepStream!.listen((event) {
      setState(() => steps = event.steps);
    });
  }

  final List<Map<String, dynamic>> items = [
    {"name": "Pizza", "cal": 500, "qty": 2},
    {"name": "Burger", "cal": 700, "qty": 1},
  ];

  @override
  Widget build(BuildContext context) {
    final screens = [
      // Profile Screen
      ProfileScreen(
        name: name,
        weight: weight,
        height: height,
        activityLevel: activityLevel,
        calorieGoal: calorieGoal,
        onUpdate: (newName, newWeight, newHeight, newActivity, newGoal) {
          setState(() {
            name = newName;
            weight = newWeight;
            height = newHeight;
            activityLevel = newActivity;
            calorieGoal = newGoal;
          });
        },
      ),

      HomeScreen(
        items: items,
        calorieGoal: calorieGoal,
        steps: steps,
      ),

      LogScreen(items: items, steps: steps),

      FriendsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, $name"),
        centerTitle: true,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // Ensures labels show
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Log"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Friends"),
        ],
      ),
    );
  }
}

// --- New Profile Screen Widget ---

class ProfileScreen extends StatefulWidget {
  final String name;
  final double weight;
  final double height;
  final double activityLevel;
  final double calorieGoal;
  final Function(String, double, double, double, double) onUpdate;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.calorieGoal,
    required this.onUpdate,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _goalController;
  double _currentActivity = 3.0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _weightController = TextEditingController(text: widget.weight.toString());
    _heightController = TextEditingController(text: widget.height.toString());
    _goalController = TextEditingController(text: widget.calorieGoal.toString());
    _currentActivity = widget.activityLevel;
  }

  void _saveData() {
    widget.onUpdate(
      _nameController.text,
      double.tryParse(_weightController.text) ?? widget.weight,
      double.tryParse(_heightController.text) ?? widget.height,
      _currentActivity,
      double.tryParse(_goalController.text) ?? widget.calorieGoal,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Weight (kg)", border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Height (cm)", border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Daily Calorie Goal", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          Text("Activity Level: ${_currentActivity.toInt()}/5"),
          Slider(
            value: _currentActivity,
            min: 1,
            max: 5,
            divisions: 4,
            label: _currentActivity.round().toString(),
            onChanged: (value) => setState(() => _currentActivity = value),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveData,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text("Save Profile"),
          ),
        ],
      ),
    );
  }
}