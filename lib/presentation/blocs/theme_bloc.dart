import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<LoadTheme>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool('isDarkMode') ?? false;
      emit(ThemeUpdated(isDarkMode));
    });

    on<ToggleTheme>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isDarkMode', event.isDarkMode);
      emit(ThemeUpdated(event.isDarkMode));
    });
  }
}

abstract class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTheme extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {
  final bool isDarkMode;
  ToggleTheme(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}

abstract class ThemeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeUpdated extends ThemeState {
  final bool isDarkMode;
  ThemeUpdated(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}
