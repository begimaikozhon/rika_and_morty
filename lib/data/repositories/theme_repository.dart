abstract class IThemeRepository {
  bool loadTheme();
  Future<void> saveTheme(bool isDarkMode);
}
