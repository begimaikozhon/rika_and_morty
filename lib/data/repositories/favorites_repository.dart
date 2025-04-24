import '../../data/models/character.dart';

abstract class IFavoritesRepository {
  List<Character> getFavorites();
  Future<void> toggleFavorite(Character character);
}
