import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rika_and_morty/data/models/character.dart';

class HiveHelper {
  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CharacterAdapter());
    }
  }

  static Future<Box<Character>> openCharacterBox() async {
    return await Hive.openBox<Character>('charactersBox');
  }

  static Future<Box<Character>> openFavoritesBox() async {
    return await Hive.openBox<Character>('favoritesBox');
  }
}
