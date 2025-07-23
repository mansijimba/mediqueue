class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://10.0.2.2:5050";
  static const String baseUrl = "$serverAddress/api";

  // Auth
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String getCurrentUser = "/auth/profile";
  static const String updateUser = "/auth/updateUser/";

  // Doctor
  static const String getAllDoctor = "/doctor/";
  static const String getDoctorById = "/doctor/";

  //Appointment
  static const String bookAppointment = "/appointment/book";
  static const String getAppointments = "/appointment/";
  static const String cancelAppointment = "/appointment/";

  //queue
  static const String getQueueStatus = "/queue/status";
}
