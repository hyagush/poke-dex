import 'package:poke_dex/src/domain/entities/pokemon_entity.dart';

abstract class PokemonRepository {
  Future<List<PokemonEntity>> fetchPokemonList();
  Future<PokemonEntity> collectPokemonDataById(int id);
}
