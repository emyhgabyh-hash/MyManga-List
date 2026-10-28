// URLs da API Kitsu
class EndPoints {
  static const String baseUrl = 'https://kitsu.io/api/edge';
  static String buscarMangas(String titulo) =>
    '$baseUrl/manga?filter%5Btext%5D=${Uri.encodeQueryComponent(titulo)}&page%5Blimit%5D=10';
  static String mangaPorId(String id) => '$baseUrl/manga/$id';
}
