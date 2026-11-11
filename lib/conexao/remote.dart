
// Faz as requisições HTTP e receber os dados da API.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Remote {
  // Faz uma requisição GET para o endereço informado
  // O resultado é convertido para JSON e retornado como Map.
  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final resposta = await http.get(
        Uri.parse(url),
        // Informa que a resposta esperada é no formato JSON:API
        headers: {'Accept': 'application/vnd.api+json'},
      ).timeout(const Duration(seconds: 15));

      // Ve se a requisição foi realizada
      if (resposta.statusCode == 200) {
        // Converte a resposta recebida para JSON
        // O UTF-8 permite exibir acentos e caracteres especiais
        return jsonDecode(utf8.decode(resposta.bodyBytes))
            as Map<String, dynamic>;
      }

      // Aqui significa que foram feitas muitas requisições
      if (resposta.statusCode == 429) {
        throw Exception('Muitas pesquisas. Aguarde alguns segundos.');
      }

      // Informa o código caso aconteça erro na API
      throw Exception('Erro na API: ${resposta.statusCode}');
    } on TimeoutException {
      // Mostra uma mensagem caso a API demore demais para responder
      throw Exception('A busca demorou demais. Verifique a internet.');
    }
  }
}