import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme_bloc.dart';
import '../widgets/character_card.dart';
import '../blocs/favorites_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Избранное"),
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
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return Center(child: Text("Избранных персонажей нет"));
            }
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final character = state.favorites[index];
                return ListTile(
                  title: Text(character.name),
                  trailing: IconButton(
                    icon: Icon(Icons.star, color: Colors.yellow),
                    onPressed: () {
                      context
                          .read<FavoritesBloc>()
                          .add(ToggleFavorite(character));
                    },
                  ),
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
