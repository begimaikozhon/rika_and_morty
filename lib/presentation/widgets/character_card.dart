import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/character.dart';
import '../blocs/favorites_bloc.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final bool isFavoriteScreen;

  const CharacterCard({required this.character, this.isFavoriteScreen = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(character.image),
        title: Text(character.name),
        subtitle: Text(character.status),
        trailing: isFavoriteScreen
            ? _buildDeleteIcon(context) // Корзина 🗑️
            : _buildFavoriteIcon(context), // Звездочка ⭐
      ),
    );
  }

  /// **🗑️ Иконка удаления из избранного (корзина)**
  Widget _buildDeleteIcon(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () => _showDeleteDialog(context),
    );
  }

  /// **⭐ Иконка добавления/удаления в избранное**
  Widget _buildFavoriteIcon(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        bool isFavorite = state is FavoritesLoaded &&
            state.favorites.any((fav) => fav.id == character.id);

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.yellow : null,
          ),
          onPressed: () {
            context
                .read<FavoritesBloc>()
                .add(ToggleFavorite(_cloneCharacter(character)));
          },
        );
      },
    );
  }

  /// **Диалог удаления персонажа**
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Удалить персонажа?"),
          content: Text(
              "Вы уверены, что хотите удалить ${character.name} из избранного?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<FavoritesBloc>()
                    .add(ToggleFavorite(_cloneCharacter(character)));
                Navigator.pop(dialogContext);
              },
              child: Text("Да", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// **⚡️ Фикс ошибки Hive: создаём новый экземпляр объекта перед сохранением**
  Character _cloneCharacter(Character character) {
    return Character(
      id: character.id,
      name: character.name,
      status: character.status,
      species: character.species,
      image: character.image,
    );
  }
}
