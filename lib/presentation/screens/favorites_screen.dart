import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme_bloc.dart';
import '../widgets/character_card.dart';
import '../blocs/favorites_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _sortType = 'name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Избранное"),
        actions: [
          DropdownButton<String>(
            value: _sortType,
            items: const [
              DropdownMenuItem(value: 'name', child: Text("По имени")),
              DropdownMenuItem(value: 'status', child: Text("По статусу")),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _sortType = value;
                });
              }
            },
          ),
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
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoaded) {
            final sortedList = state.sorted(_sortType);

            if (sortedList.isEmpty) {
              return Center(child: Text("Избранных персонажей нет"));
            }
            return ListView.builder(
              itemCount: sortedList.length,
              itemBuilder: (context, index) {
                final character = sortedList[index];
                return CharacterCard(
                  character: character,
                  isFavoriteScreen: true,
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
