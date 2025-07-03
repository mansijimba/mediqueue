import 'package:flutter/widgets.dart';

import 'package:mediqueue/app/app.dart';
import 'package:mediqueue/app/service_locator/service_locator.dart';
import 'package:mediqueue/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies and HiveService together
  await initDependencies();
  await HiveService().init();

  runApp(MyApp());
}
