import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rika_and_morty/core/hive_helper.dart';
import 'package:rika_and_morty/data/api_service.dart';
import 'package:rika_and_morty/data/repositories/character_repository_impl.dart';
import 'package:rika_and_morty/data/repositories/favorites_repository.dart';
import 'package:rika_and_morty/data/repositories/favorites_repository_impl.dart';
import 'package:rika_and_morty/data/repositories/theme_repository_impl.dart';
import 'package:rika_and_morty/presentation/blocs/character_bloc.dart';
import 'package:rika_and_morty/presentation/blocs/favorites_bloc.dart';
import 'package:rika_and_morty/presentation/blocs/theme_bloc.dart';
import 'package:rika_and_morty/presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();

  final settingsBox = await Hive.openBox('settings');
  final characterBox = await HiveHelper.openCharacterBox();
  final favoritesBox = await HiveHelper.openFavoritesBox();

  final characterRepository =
      CharacterRepositoryImpl(ApiService(), characterBox);
  final favoritesRepository = FavoritesRepositoryImpl(favoritesBox);
  final themeRepository = ThemeRepositoryImpl(settingsBox);

  runApp(MyApp(
    characterRepository: characterRepository,
    settingsBox: settingsBox,
    favoritesRepository: favoritesRepository,
    themeRepository: themeRepository,
  ));
}

class MyApp extends StatelessWidget {
  final CharacterRepositoryImpl characterRepository;
  final IFavoritesRepository favoritesRepository;
  final ThemeRepositoryImpl themeRepository;
  final Box settingsBox;

  const MyApp({
    required this.characterRepository,
    required this.settingsBox,
    required this.favoritesRepository,
    required this.themeRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                CharacterBloc(characterRepository)..add(LoadCharacters())),
        BlocProvider(
            create: (_) =>
                FavoritesBloc(favoritesRepository)..add(LoadFavorites())),
        BlocProvider(
            create: (_) => ThemeBloc(themeRepository)..add(LoadTheme())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final isDarkMode = state is ThemeUpdated ? state.isDarkMode : false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Rick and Morty Characters',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: MainScreen(),
          );
        },
      ),
    );
  }
}
