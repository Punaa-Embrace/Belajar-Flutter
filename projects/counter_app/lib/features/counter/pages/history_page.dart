import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<int> history;

  const HistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: history.isEmpty
          ? const Center(child: Text("Belum ada data 😴"))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text("Count: ${history[index]}"),
                );
              },
            ),
    );
  }
}