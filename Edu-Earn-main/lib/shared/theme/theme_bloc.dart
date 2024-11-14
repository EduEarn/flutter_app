import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

// States
class ThemeState {
  final ThemeMode themeMode;

  ThemeState(this.themeMode);
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(ThemeMode.system)) {
    on<ToggleThemeEvent>((event, emit) {
      emit(ThemeState(
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      ));
    });
  }
}