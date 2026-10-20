import 'dart:convert';
import 'package:http/http.dart' as http;

class JikanService {
  static const String baseUrl =
      'https://api.jikan.moe/v4/manga';

  Future<List<dynamic>> buscarMangas(String titulo) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'q': titulo,
        'limit': '10',
      },
    );

    final resposta = await http.get(uri);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      return dados['data'] as List<dynamic>;
    } else {
      throw Exception('Erro ao buscar mangás.');
    }
  }
}