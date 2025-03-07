import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/character.dart';
import 'package:hive/hive.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final Box<Character> _favoritesBox;

  FavoritesBloc(this._favoritesBox) : super(FavoritesLoaded([])) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoaded(_favoritesBox.values.toList()));
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<FavoritesState> emit) async {
    final character = event.character;

    print(
        "📦 Текущий список избранных: ${_favoritesBox.values.map((c) => c.id).toList()}");
    print("⭐ Обрабатываем персонажа с ID: ${character.id}");

    if (_favoritesBox.containsKey(character.id)) {
      await _favoritesBox.delete(character.id);
      print("❌ Персонаж удалён из избранного");
    } else {
      final newCharacter = Character(
        id: character.id,
        name: character.name,
        status: character.status,
        species: character.species,
        image: character.image,
      );

      await _favoritesBox.put(character.id, newCharacter);
      print("✅ Персонаж добавлен в избранное");
    }

    // 🔹 Проверяем `emit.isDone`, чтобы избежать ошибки
    if (!emit.isDone) {
      emit(FavoritesLoaded(_favoritesBox.values.toList()));
    }
  }
}

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final Character character;
  ToggleFavorite(this.character);

  @override
  List<Object?> get props => [character];
}

abstract class FavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesLoaded extends FavoritesState {
  final List<Character> favorites;
  FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}
