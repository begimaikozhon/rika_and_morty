// favorites_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/character.dart';
import '../../data/repositories/favorites_repository.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final IFavoritesRepository repository;

  FavoritesBloc(this.repository) : super(FavoritesLoaded([])) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) {
    emit(FavoritesLoaded(repository.getFavorites()));
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<FavoritesState> emit) async {
    await repository.toggleFavorite(event.character);
    emit(FavoritesLoaded(repository.getFavorites()));
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

  List<Character> sorted(String sortType) {
    final sortedList = List<Character>.from(favorites);
    if (sortType == 'name') {
      sortedList.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortType == 'status') {
      sortedList.sort((a, b) => a.status.compareTo(b.status));
    }
    return sortedList;
  }

  @override
  List<Object?> get props => [favorites];
}
