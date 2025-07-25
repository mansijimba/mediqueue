import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/auth/presentation/view/login.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_view_model.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_view_model.dart';
import 'package:mediqueue/app/service_locator/service_locator.dart';
import 'package:mediqueue/features/queue/domain/use_case/get_queue_status_usecase.dart';
import 'package:mediqueue/features/queue/presentation/view_model/queue_view_model.dart'; // Assuming you have this

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterViewModel>.value(
          value: serviceLocator<RegisterViewModel>(),
        ),
        BlocProvider<LoginViewModel>.value(
          value: serviceLocator<LoginViewModel>(),
        ),
        BlocProvider<QueueViewModel>(
          create:
              (context) => QueueViewModel(
                getQueueStatusUseCase: serviceLocator<GetQueueStatusUseCase>(),
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(), // now LoginPage has access to LoginViewModel
      ),
    );
  }
}
