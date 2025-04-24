import 'package:hive/hive.dart';
import '../../data/models/character.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryImpl implements IFavoritesRepository {
  final Box<Character> favoritesBox;

  FavoritesRepositoryImpl(this.favoritesBox);

  @override
  List<Character> getFavorites() {
    return favoritesBox.values.toList();
  }

  @override
  Future<void> toggleFavorite(Character character) async {
    if (favoritesBox.containsKey(character.id)) {
      await favoritesBox.delete(character.id);
    } else {
      await favoritesBox.put(character.id, character);
    }
  }
}
