import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'log_screen.dart';
import 'friends_screen.dart';

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

  // Shared food list
  final List<Map<String, String>> items = [
    {"name": "Pizza", "cal": "500", "qty": "2"},
    {"name": "Burger", "cal": "700", "qty": "1"},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const Center(
        child: Text("Profile"),
      ),

      HomeScreen(items: items),

      LogScreen(items: items),

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
          setState(() {
            _currentIndex = index;
          });
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