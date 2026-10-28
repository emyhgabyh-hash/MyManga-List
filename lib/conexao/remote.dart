import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Remote {
  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final resposta = await http.get(Uri.parse(url),
        headers: {'Accept': 'application/vnd.api+json'})
        .timeout(const Duration(seconds: 15));
      if (resposta.statusCode == 200) {
        return jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
      }
      if (resposta.statusCode == 429) {
        throw Exception('Muitas pesquisas. Aguarde alguns segundos.');
      }
      throw Exception('Erro na API: ${resposta.statusCode}');
    } on TimeoutException {
      throw Exception('A busca demorou demais. Verifique a internet.');
    }
  }
}