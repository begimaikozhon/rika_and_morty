import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final Box settingsBox;

  ThemeBloc(this.settingsBox) : super(ThemeInitial()) {
    on<LoadTheme>((event, emit) {
      final isDarkMode = settingsBox.get('isDarkMode', defaultValue: false) as bool;
      emit(ThemeUpdated(isDarkMode));
    });

    on<ToggleTheme>((event, emit) {
      settingsBox.put('isDarkMode', event.isDarkMode);
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
