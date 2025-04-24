import 'package:hive/hive.dart';
import 'theme_repository.dart';

class ThemeRepositoryImpl implements IThemeRepository {
  final Box settingsBox;

  ThemeRepositoryImpl(this.settingsBox);

  @override
  bool loadTheme() {
    return settingsBox.get('isDarkMode', defaultValue: false) as bool;
  }

  @override
  Future<void> saveTheme(bool isDarkMode) async {
    await settingsBox.put('isDarkMode', isDarkMode);
  }
}
