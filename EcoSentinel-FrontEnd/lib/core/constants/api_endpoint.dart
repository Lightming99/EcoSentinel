// lib/core/constants/api_endpoints.dart

class ApiEndpoints {
  static const String baseUrl = 'https://your-backend-api.com/api';

  // Existing endpoints...
  static const String chatMessage = '$baseUrl/chat/message';
  static const String chatHistory = '$baseUrl/chat/history';

  // New feedback endpoint
  static const String chatFeedback = '$baseUrl/chat/feedback';

  // Environmental data endpoints
  static const String environmentalData = '$baseUrl/environmental/data';
  static const String airQuality = '$baseUrl/environmental/air-quality';
  static const String waterQuality = '$baseUrl/environmental/water-quality';

  // Policy endpoints
  static const String policies = '$baseUrl/policies';
  static const String policySearch = '$baseUrl/policies/search';

  // Report endpoints
  static const String reportSubmit = '$baseUrl/reports/submit';
  static const String reportHistory = '$baseUrl/reports/history';

  // User endpoints
  static const String userProfile = '$baseUrl/user/profile';
  static const String userSettings = '$baseUrl/user/settings';
}
