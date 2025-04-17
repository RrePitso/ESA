import 'package:flutter/material.dart';

class MoodVisualizer extends StatelessWidget {
  final List<Map<String, String>> entries;

  MoodVisualizer(this.entries);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: entries.map((entry) {
          return Row(
            children: [
              Text('• ${entry['emotion']}'),
              SizedBox(width: 8),
              Expanded(
                child: Text(entry['entry']!, overflow: TextOverflow.ellipsis),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
