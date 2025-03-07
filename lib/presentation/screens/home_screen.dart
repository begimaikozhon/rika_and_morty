import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rika_and_morty/presentation/blocs/theme_bloc.dart';
import '../blocs/character_bloc.dart';
import '../widgets/character_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CharacterBloc>().add(LoadCharacters());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Список персонажей"),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              bool isDarkMode =
                  state is ThemeUpdated ? state.isDarkMode : false;
              return IconButton(
                icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleTheme(!isDarkMode));
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CharacterLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.characters.length,
              itemBuilder: (context, index) {
                return CharacterCard(character: state.characters[index]);
              },
            );
          } else {
            return Center(child: Text("Ошибка загрузки"));
          }
        },
      ),
    );
  }
}
