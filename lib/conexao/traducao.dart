// Tradução opcional das sinopses. Se falhar, mantém o texto original.
import 'dart:convert';
import 'package:http/http.dart' as http;

class Traducao {
  static final Map<String, String> _cache = {};

  static Future<String> traduzir(String texto) async {
    if (texto.trim().isEmpty || texto == 'Sinopse não disponível.') return texto;
    if (_cache.containsKey(texto)) return _cache[texto]!;

    // O serviço gratuito limita o tamanho da consulta. Mostramos um resumo traduzido.
    final caracteres = texto.runes.toList();
    var trecho = String.fromCharCodes(caracteres.take(350));
    while (utf8.encode(trecho).length > 450 && trecho.isNotEmpty) {
      trecho = trecho.substring(0, trecho.length - 1);
    }
    final uri = Uri.https('api.mymemory.translated.net', '/get', {
      'q': trecho,
      'langpair': 'en|pt-BR',
    });
    try {
      final resposta = await http.get(uri).timeout(const Duration(seconds: 8));
      if (resposta.statusCode != 200) return texto;
      final json = jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
      final dados = json['responseData'] as Map<String, dynamic>?;
      final traducao = dados?['translatedText']?.toString() ?? '';
      if (traducao.isEmpty || traducao.toUpperCase().contains('MYMEMORY WARNING')) return texto;
      final resultado = traducao + (caracteres.length > 350 ? '…' : '');
      _cache[texto] = resultado;
      return resultado;
    } catch (_) {
      return texto;
    }
  }
}
