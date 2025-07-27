import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_view_model.dart';
import 'package:mediqueue/features/home/domain/usecase/home_usecase.dart';
import 'package:mediqueue/features/home/presentation/view_model/home_state.dart';
import 'package:mediqueue/features/home/presentation/view_model/home_event.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final LogoutUseCase logoutUseCase;
  final LoginViewModel loginViewModel;

  BuildContext? currentContext;

  HomeViewModel({
    required this.logoutUseCase,
    required this.loginViewModel,
  }) : super(HomeState.initial()) {
    on<TabChanged>(_onTabChanged);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void setContext(BuildContext context) {
    currentContext = context;
  }

  Future<void> _onTabChanged(TabChanged event, Emitter<HomeState> emit) async {
    emit(state.copyWith(selectedIndex: event.index));
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoggingOut: true));
    await logoutUseCase.execute(event.context);
    emit(state.copyWith(isLoggingOut: false));
  }

  @override
  Future<void> close() {
    currentContext = null;
    return super.close();
  }
}
