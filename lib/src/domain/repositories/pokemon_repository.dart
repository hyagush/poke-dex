import 'package:poke_dex/src/domain/models/pokemon_model.dart';

abstract class PokemonRepository {
  Future<List<PokemonModel>> fetchPokemonList();
  Future<PokemonModel> collectPokemonDataById(int id);
}
