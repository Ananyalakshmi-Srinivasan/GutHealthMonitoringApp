import 'package:flutter/material.dart';

class JournalPage extends StatelessWidget {
  final String journal;

  const JournalPage({
    super.key,
    required this.journal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        backgroundColor: const Color(0xFF1B9FAE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: Text(
            journal.isEmpty ? 'No journal for this day.' : journal,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}