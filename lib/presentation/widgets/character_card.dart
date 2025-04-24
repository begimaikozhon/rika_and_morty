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
        leading: Image.network(
          character.image,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.broken_image),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              width: 48,
              height: 48,
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
        title: Text(character.name),
        subtitle: Text(character.status),
        trailing: isFavoriteScreen
            ? _buildDeleteIcon(context)
            : _buildFavoriteIcon(context),
      ),
    );
  }

  Widget _buildDeleteIcon(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: IconButton(
        key: ValueKey('delete_${character.id}'),
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () => _showDeleteDialog(context),
      ),
    );
  }

  Widget _buildFavoriteIcon(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        bool isFavorite = state is FavoritesLoaded &&
            state.favorites.any((fav) => fav.id == character.id);

        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: IconButton(
            key: ValueKey(isFavorite),
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.yellow : null,
            ),
            onPressed: () {
              context
                  .read<FavoritesBloc>()
                  .add(ToggleFavorite(_cloneCharacter(character)));
            },
          ),
        );
      },
    );
  }

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
