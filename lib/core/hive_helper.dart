import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/character.dart';

class HiveHelper {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CharacterAdapter()); // Генерируем адаптер
  }

  static Future<Box<Character>> openCharacterBox() async {
    return await Hive.openBox<Character>('charactersBox'); // Кешируем персонажей
  }

  static Future<Box<Character>> openFavoritesBox() async {
    return await Hive.openBox<Character>('favoritesBox'); // Сохраняем избранных
  }
}
