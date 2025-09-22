abstract class PokemonSource {
  Future<Map<String, dynamic>?> fetchPokemonList();
  Future<Map<String, dynamic>?> collectPokemonDataById(int id);
}
