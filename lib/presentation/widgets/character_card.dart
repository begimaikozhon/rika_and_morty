import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/character.dart';
import '../blocs/favorites_bloc.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final bool isFavoriteScreen; // Новый параметр

  const CharacterCard({required this.character, this.isFavoriteScreen = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(character.image),
        title: Text(character.name),
        subtitle: Text(character.status),
        trailing: isFavoriteScreen
            ? IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(context, character),
              )
            : BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  bool isFavorite = false;
                  if (state is FavoritesLoaded) {
                    isFavorite = state.favorites.any((fav) => fav.id == character.id);
                  }
                  return IconButton(
                    icon: Icon(isFavorite ? Icons.star : Icons.star_border, color: isFavorite ? Colors.yellow : null),
                    onPressed: () {
                      context.read<FavoritesBloc>().add(ToggleFavorite(character));
                    },
                  );
                },
              ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Character character) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Удалить персонажа?"),
          content: Text("Вы уверены, что хотите удалить ${character.name} из избранного?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), // Закрываем диалог
              child: Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                context.read<FavoritesBloc>().add(ToggleFavorite(character));
                Navigator.pop(dialogContext); // Закрываем диалог
              },
              child: Text("Да", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
