import 'package:flutter/material.dart';
import '../services/emotion_api_service.dart';
import '../widgets/mood_visualizer.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _journalController = TextEditingController();
  List<Map<String, String>> _entries =
      []; // Stores journal entries and emotions

  void _saveEntry(String text) async {
    // Call the emotion prediction service
    String emotion = await EmotionApiService.getPredictedEmotion(text);
    setState(() {
      _entries.add({'entry': text, 'emotion': emotion});
    });
    _journalController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _journalController,
              decoration: InputDecoration(
                labelText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_journalController.text.isNotEmpty) {
                _saveEntry(_journalController.text);
              }
            },
            child: Text('Save Entry'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return ListTile(
                  title: Text(entry['entry']!),
                  subtitle: Text('Emotion: ${entry['emotion']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
