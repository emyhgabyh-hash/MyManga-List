
// Guarda os endereços da API Kitsu

class EndPoints {
  // Endereço principal da API
  static const String baseUrl = 'https://kitsu.io/api/edge';

  // Monta o endereço para pesquisar mangás pelo título API
  // Define que serão retornados até 10 resultados.
  static String buscarMangas(String titulo) =>
      '$baseUrl/manga?filter%5Btext%5D=${Uri.encodeQueryComponent(titulo)}&page%5Blimit%5D=10';

  // Monta o endereço para buscar um mangá específico pelo ID API
  static String mangaPorId(String id) => '$baseUrl/manga/$id';
}
