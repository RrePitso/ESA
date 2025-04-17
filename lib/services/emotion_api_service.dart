import 'dart:convert';
import 'package:http/http.dart' as http;

class EmotionApiService {
  static const String _apiUrl =
      'https://your-backend-url/emotions'; // Replace with actual backend URL

  static Future<String> getPredictedEmotion(String text) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[
          'emotion']; // Assuming the backend returns {"emotion": "happy"}
    } else {
      throw Exception('Failed to predict emotion');
    }
  }
}
