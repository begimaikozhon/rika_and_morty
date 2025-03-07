import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rika_and_morty/core/hive_helper.dart';
import 'package:rika_and_morty/data/api_service.dart';
import 'package:rika_and_morty/data/models/character.dart';
import 'package:rika_and_morty/presentation/blocs/character_bloc.dart';
import 'package:rika_and_morty/presentation/blocs/favorites_bloc.dart';
import 'package:rika_and_morty/presentation/blocs/theme_bloc.dart';
import 'package:rika_and_morty/presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  // await Hive.deleteBoxFromDisk(
  //     'favoritesBox'); // Очистка хранилища избранного перед запуском
  // await Hive.deleteBoxFromDisk('charactersBox'); // Очистка кеша персонажей

  final settingsBox = await Hive.openBox('settings');
  final characterBox = await HiveHelper.openCharacterBox();
  final favoritesBox = await HiveHelper.openFavoritesBox();

  runApp(MyApp(
    characterBox: characterBox,
    favoritesBox: favoritesBox,
    settingsBox: settingsBox,
  ));
}

class MyApp extends StatelessWidget {
  final Box<Character> characterBox;
  final Box<Character> favoritesBox;
  final Box settingsBox;

  const MyApp(
      {required this.characterBox,
      required this.favoritesBox,
      required this.settingsBox});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => CharacterBloc(ApiService(), characterBox)
              ..add(LoadCharacters())),
        BlocProvider(
            create: (context) =>
                FavoritesBloc(favoritesBox)..add(LoadFavorites())),
        BlocProvider(
            create: (context) => ThemeBloc(settingsBox)..add(LoadTheme())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          bool isDarkMode = state is ThemeUpdated ? state.isDarkMode : false;
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
