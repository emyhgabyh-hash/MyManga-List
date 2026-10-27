// Guarda todos os endereços (URLs) da API usada no app: Kitsu
// Mais fácil de trocar de API no futuro, pois só este arquivo muda

class EndPoints {
  // Endereço base da API
  static const String baseUrl = 'https://kitsu.io/api/edge';

  // Busca mangás pelo título (limite de 10 resultados)
  // %5B e %5D são os caracteres [ e ] codificados na URL
  static String buscarMangas(String titulo) =>
      '$baseUrl/manga?filter%5Btext%5D=${Uri.encodeQueryComponent(titulo)}&page%5Blimit%5D=10';

  // Busca um mangá específico pelo ID
  static String mangaPorId(String id) => '$baseUrl/manga/$id';
}