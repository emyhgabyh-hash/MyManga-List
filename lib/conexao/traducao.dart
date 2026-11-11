
// Responsável por tentar traduzir as sinopses para português.
// Se a tradução falhar, mantém o texto original.

import 'dart:convert';
import 'package:http/http.dart' as http;

class Traducao {
  // Guarda traduções já realizadas para evitar repetir requisições
  static final Map<String, String> _cache = {};

  // Recebe uma sinopse e tenta traduzi-la API
  static Future<String> traduzir(String texto) async {
    // Verifica se existe texto para traduzir
    if (texto.trim().isEmpty || texto == 'Sinopse não disponível.') {
      return texto;
    }

    // Verifica se a tradução já está armazenada
    if (_cache.containsKey(texto)) return _cache[texto]!;

    // Separa o texto para limitar o tamanho enviado
    final caracteres = texto.runes.toList();
    var trecho = String.fromCharCodes(caracteres.take(350));

    // Garante que o texto não ultrapasse o limite da requisição
    while (utf8.encode(trecho).length > 450 && trecho.isNotEmpty) {
      trecho = trecho.substring(0, trecho.length - 1);
    }

    // Monta o endereço da API de tradução
    final uri = Uri.https('api.mymemory.translated.net', '/get', {
      'q': trecho,
      'langpair': 'en|pt-BR',
    });

    try {
      // Envia uma requisição GET para o serviço de tradução API
      final resposta = await http.get(uri)
          .timeout(const Duration(seconds: 8));

      // Verifica se a resposta foi recebida corretamente
      if (resposta.statusCode != 200) return texto;

      // Converte a resposta recebida para JSON
      final json = jsonDecode(utf8.decode(resposta.bodyBytes))
          as Map<String, dynamic>;

      // Pega o texto traduzido dentro da resposta
      final dados = json['responseData'] as Map<String, dynamic>?;
      final traducao = dados?['translatedText']?.toString() ?? '';

      // Verifica se a tradução está vazia ou retornou um aviso
      if (traducao.isEmpty ||
          traducao.toUpperCase().contains('MYMEMORY WARNING')) {
        return texto;
      }

      // Indica que o restante da sinopse não foi traduzido
      final resultado = traducao +
          (caracteres.length > 350 ? '…' : '');

      // Guarda a tradução para utilizar novamente
      _cache[texto] = resultado;

      return resultado;
    } catch (_) {
      // Se acontecer algum erro, retorna a sinopse original
      return texto;
    }
  }
}