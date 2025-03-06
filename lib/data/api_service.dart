import 'package:dio/dio.dart';
import 'models/character.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Character>> fetchCharacters(int page) async {
    final response = await _dio.get("https://rickandmortyapi.com/api/character?page=$page");
    
    if (response.statusCode == 200) {
      List results = response.data['results'];
      return results.map((e) => Character.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load characters");
    }
  }
}
