import 'package:flutter/material.dart';

abstract class HomeEvent {}

class TabChanged extends HomeEvent {
  final int index;

  TabChanged(this.index);
}

class LogoutRequested extends HomeEvent {
  final BuildContext context;

  LogoutRequested(this.context);
}
