import 'package:flutter/material.dart';
import 'app_layout.dart';

class FriendsScreen extends StatelessWidget {
  FriendsScreen({super.key});

  final List<Map<String, String>> friends = List.generate(
    4,
    (index) => {
      "name": "David",
      "score": "100",
      "rank": "71",
    },
  );

  // Popup dialog
  void _showProfile(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Profile"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return AppLayout(
      child: Column(
        children: [
          const SizedBox(height: 20),

          const Text(
            "Logging",
            style: TextStyle(fontSize: 22),
          ),

          const SizedBox(height: 10),

          const Text("32 Days - On Track"),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      _showProfile(
                        context,
                        friends[index]["name"]!,
                      );
                    },

                    child: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),

                  title: Text(friends[index]["name"]!),

                  subtitle: Text(
                    "Score: ${friends[index]["score"]}",
                  ),

                  trailing: Text(
                    friends[index]["rank"]!,
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}