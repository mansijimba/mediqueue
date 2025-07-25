abstract class HomeEvent {}

class TabTapped extends HomeEvent {
  final int index;
  TabTapped(this.index);
}

class LogoutRequested extends HomeEvent {}

class ShakeDetected extends HomeEvent {}
