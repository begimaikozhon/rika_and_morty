import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/character.dart';
import '../../data/repositories/character_repository.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final ICharacterRepository repository;

  CharacterBloc(this.repository) : super(CharacterLoading()) {
    on<LoadCharacters>(_onLoadCharacters);
  }

  Future<void> _onLoadCharacters(
      LoadCharacters event, Emitter<CharacterState> emit) async {
    try {
      final characters = await repository.fetchCharacters();
      emit(CharacterLoaded(characters: characters));
    } catch (_) {
      final cached = await repository.fetchFromCache();
      if (cached.isNotEmpty) {
        emit(CharacterLoaded(characters: cached));
      } else {
        emit(CharacterError("Ошибка загрузки и нет данных в кеше"));
      }
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
