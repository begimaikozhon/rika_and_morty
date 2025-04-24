import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/theme_repository.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final IThemeRepository repository;

  ThemeBloc(this.repository) : super(ThemeInitial()) {
    on<LoadTheme>((event, emit) {
      final isDarkMode = repository.loadTheme();
      emit(ThemeUpdated(isDarkMode));
    });

    on<ToggleTheme>((event, emit) async {
      await repository.saveTheme(event.isDarkMode);
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
