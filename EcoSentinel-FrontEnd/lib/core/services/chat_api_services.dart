import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/models/chat_message.dart';
import 'package:dio/dio.dart';

class ChatApiService {
  // For Flutter Web (Chrome) - use localhost when Rasa is on same machine
  static const String rasaUrl = 'http://localhost:5005';
  static const Duration timeout = Duration(seconds: 30);
  final Dio _dio = Dio();
  static const String neo4jUrl = 'https://your-backend-api.com/api';

  Future<List<ChatMessage>> sendMessage(String message) async {
    try {
      print('Sending message to Rasa: $message'); // Debug log

      final response = await http
          .post(
            Uri.parse('$rasaUrl/webhooks/rest/webhook'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'sender': 'user', // You might want to use a unique sender ID
              'message': message,
            }),
          )
          .timeout(timeout);

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Rasa returns a list of message objects directly
        if (data is List) {
          List<ChatMessage> messages = [];

          for (var item in data) {
            if (item is Map<String, dynamic>) {
              messages.add(ChatMessage(
                id: '${DateTime.now().millisecondsSinceEpoch}_${messages.length}', // Ensure unique IDs
                text: item['text'] ?? 'Empty response',
                isUser: false,
                timestamp: DateTime.now(),
              ));
            }
          }

          // Return all messages or a default message if empty
          return messages.isNotEmpty ? messages : [_getDefaultErrorMessage()];
        } else {
          print('Unexpected response format: $data');
          return [_getDefaultErrorMessage()];
        }
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to send message. Status: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('Client Exception: $e');
      throw Exception(
          'Network connection error. Please check your internet connection.');
    } on FormatException catch (e) {
      print('Format Exception: $e');
      throw Exception('Invalid response format from server.');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to communicate with chat server: $e');
    }
  }

  // Alternative method that returns a single message (backward compatibility)
  Future<ChatMessage> sendMessageSingle(String message) async {
    try {
      final messages = await sendMessage(message);
      return messages.first;
    } catch (e) {
      return _getDefaultErrorMessage();
    }
  }

  ChatMessage _getDefaultErrorMessage() {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Sorry, I couldn\'t process your message. Please try again.',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  // Method to test connection to Rasa server
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$rasaUrl/'),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 10));

      print('Connection test - Status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Method to get server status
  Future<Map<String, dynamic>?> getServerStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$rasaUrl/status'),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Status check failed: $e');
      return null;
    }
  }

  /// Submit feedback for a chat message to be stored in Neo4j
  Future<void> submitFeedback({
    required String messageId,
    required String messageText,
    required bool isPositive,
    String? comment,
    List<String>? categories,
  }) async {
    try {
      final response = await _dio.post(
        '$neo4jUrl/chat/feedback',
        data: {
          'messageId': messageId,
          'messageText': messageText,
          'isPositive': isPositive,
          'comment': comment,
          'categories': categories,
          'timestamp': DateTime.now().toIso8601String(),
          'sessionId': _getSessionId(), // You might want to track session IDs
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to submit feedback');
      }
    } catch (e) {
      throw Exception('Error submitting feedback: $e');
    }
  }

  /// Get session ID for tracking user sessions
  String _getSessionId() {
    // Implement your session tracking logic here
    // This could be stored in SharedPreferences or generated per app session
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
