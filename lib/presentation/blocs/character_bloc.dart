import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/api_service.dart';
import '../../data/models/character.dart';
import 'package:hive/hive.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final ApiService apiService;
  final Box<Character> characterBox;
  int _currentPage = 1;
  bool _isFetching = false;

  CharacterBloc(this.apiService, this.characterBox)
      : super(CharacterLoading()) {
    on<LoadCharacters>(_onLoadCharacters);
  }

  Future<void> _onLoadCharacters(
      LoadCharacters event, Emitter<CharacterState> emit) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      // Проверяем, есть ли кешированные данные
      if (characterBox.isNotEmpty && state is CharacterLoading) {
        print("📦 Загружаем данные из кеша...");
        emit(CharacterLoaded(characters: characterBox.values.toList()));
      }

      print("🌍 Загружаем данные с API...");
      final characters = await apiService.fetchCharacters(_currentPage);
      _currentPage++;

      // Преобразуем список в Map для сохранения в Hive
      final characterMap = {for (var c in characters) c.id: c};
      await characterBox.putAll(characterMap);

      print("✅ Данные загружены и сохранены в Hive!");

      emit(CharacterLoaded(characters: characterBox.values.toList()));
    } catch (e) {
      print("❌ Ошибка загрузки: $e");
      emit(CharacterError("Ошибка загрузки персонажей"));
    } finally {
      _isFetching = false;
    }
  }
}

abstract class CharacterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCharacters extends CharacterEvent {}

abstract class CharacterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<Character> characters;
  CharacterLoaded({required this.characters});

  @override
  List<Object?> get props => [characters];
}

class CharacterError extends CharacterState {
  final String message;
  CharacterError(this.message);

  @override
  List<Object?> get props => [message];
}
