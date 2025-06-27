class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  //For Android Emulator
  static const String serverAddress = "http://10.0.2.2:3000";
  // For iOS Simulator
  // static const String serverAddress = "http://localhost:3000";

  // For iPhone (uncomment if needed)
  static const String baseUrl = "$serverAddress/api/v1/";
  static const String imageUrl = "$baseUrl/uploads/";

  // Auth
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String getAllUser = "auth/getAllUser";
  static const String updateUser = "auth/updateUser/";
  static const String deleteUser = "auth/deleteUser/";
}
