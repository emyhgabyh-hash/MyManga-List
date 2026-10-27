// Responsável por fazer a requisição HTTP e devolver o JSON já convertido

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Remote {
  // Faz um GET na URL informada e retorna o JSON como Map
  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final resposta = await http
          .get(
            Uri.parse(url),
            // A Kitsu responde no formato JSON:API
            headers: {'Accept': 'application/vnd.api+json'},
          )
          .timeout(const Duration(seconds: 15));

      // 200 = deu certo
      if (resposta.statusCode == 200) {
        // utf8.decode garante que acentos e caracteres especiais apareçam certo
        return jsonDecode(utf8.decode(resposta.bodyBytes))
            as Map<String, dynamic>;
      }

      // 429 = muitas requisições em pouco tempo
      if (resposta.statusCode == 429) {
        throw Exception(
          'A API recebeu muitas pesquisas. Aguarde alguns segundos e tente novamente.',
        );
      }

      throw Exception('Erro na API. Código: ${resposta.statusCode}');
    } on TimeoutException {
      throw Exception(
        'A busca demorou demais. Verifique sua internet e tente novamente.',
      );
    }
  }
}