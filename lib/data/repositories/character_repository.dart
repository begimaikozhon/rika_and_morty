import '../../data/models/character.dart';

abstract class ICharacterRepository {
  Future<List<Character>> fetchCharacters();
  Future<List<Character>> fetchFromCache();
}
