import 'package:hive/hive.dart';

part 'character.g.dart'; // Для генерации адаптера

@HiveType(typeId: 1)
class Character extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String image;

  Character({required this.id, required this.name, required this.status, required this.species, required this.image});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      image: json['image'],
    );
  }
}
