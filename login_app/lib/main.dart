import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'log_screen.dart';
import 'friends_screen.dart';
import 'package:pedometer/pedometer.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    ),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  double calorieGoal = 3000;
  int steps = 0;

  Stream<StepCount>? _stepStream;

  @override
  void initState() {
    super.initState();

    _stepStream = Pedometer.stepCountStream;

    _stepStream!.listen((event) {
      setState(() {
        steps = event.steps;
      });
    });
  }

  final List<Map<String, dynamic>> items = [
    {"name": "Pizza", "cal": 500, "qty": 2},
    {"name": "Burger", "cal": 700, "qty": 1},
  ];

  @override
  Widget build(BuildContext context) {
    final screens = [
      const Center(child: Text("Profile")),

      HomeScreen(
        items: items,
        calorieGoal: calorieGoal,
        steps: steps,
      ),

      LogScreen(
        items: items,
        steps: steps,
      ),

      FriendsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("09:52 AM"),
        centerTitle: true,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "MyProfile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: "Log",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Friends",
          ),
        ],
      ),
    );
  }
}