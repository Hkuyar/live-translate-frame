import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GptService {
  final _apiKey = dotenv.env['OPENAI_API_KEY']!;
  final _endpoint = Uri.parse('https://api.openai.com/v1/chat/completions');

  Future<String?> translateToEnglish(String text) async {
    final response = await http.post(
      _endpoint,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4.1-nano',
        'messages': [
          { 'role': 'user', 'content': 'Translate this into English: "$text"' }
        ],
        'temperature': 0.3,
      }),
    );
    if (response.statusCode != 200) return null;
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'] as String?;
  }
}
