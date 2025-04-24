import 'package:hive/hive.dart';
import 'package:rika_and_morty/data/api_service.dart';
import 'package:rika_and_morty/data/models/character.dart';
import 'character_repository.dart';

class CharacterRepositoryImpl implements ICharacterRepository {
  final ApiService apiService;
  final Box<Character> characterBox;
  int _currentPage = 1;
  bool _hasReachedEnd = false;

  CharacterRepositoryImpl(this.apiService, this.characterBox);

  @override
  Future<List<Character>> fetchCharacters() async {
    if (_hasReachedEnd) return characterBox.values.toList();

    try {
      final characters = await apiService.fetchCharacters(_currentPage);
      _currentPage++;

      if (characters.isEmpty) _hasReachedEnd = true;

      final characterMap = {for (var c in characters) c.id: c};
      await characterBox.putAll(characterMap);

      return characterBox.values.toList();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<Character>> fetchFromCache() async {
    return characterBox.values.toList();
  }
}
