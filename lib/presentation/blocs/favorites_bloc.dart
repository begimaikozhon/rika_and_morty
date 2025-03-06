import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/character.dart';
import 'package:hive/hive.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final Box<Character> _favoritesBox;

  FavoritesBloc(this._favoritesBox) : super(FavoritesLoaded([])) {
    on<LoadFavorites>((event, emit) {
      emit(FavoritesLoaded(_favoritesBox.values.toList()));
    });

    on<ToggleFavorite>((event, emit) {
      final currentFavorites = _favoritesBox.values.toList();
      if (currentFavorites.any((c) => c.id == event.character.id)) {
        _favoritesBox.delete(event.character.id);
      } else {
        _favoritesBox.put(event.character.id, event.character);
      }
      emit(FavoritesLoaded(_favoritesBox.values.toList()));
    });
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
