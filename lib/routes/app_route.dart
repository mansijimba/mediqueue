import 'package:mediqueue/View/login.dart';
import 'package:mediqueue/View/splashscreen.dart';

class AppRoute {
  AppRoute._();

  static const String splashScreenRoute = '/';
  static const String loginRoute = '/home';

  static getAppRoutes() {
    return {
      splashScreenRoute: (context) => const SplashScreen(),
      loginRoute: (context) => const LoginPage(),
    };
  }
}
