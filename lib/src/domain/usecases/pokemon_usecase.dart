import 'package:poke_dex/src/domain/entities/pokemon_entity.dart';
import 'package:poke_dex/src/domain/repositories/pokemon_repository.dart';

class PokemonUsecase {
  final PokemonRepository _pokemonRepository;
  PokemonUsecase(this._pokemonRepository);

  Future<List<PokemonEntity>> fetchPokemonList() => _pokemonRepository.fetchPokemonList();
  Future<PokemonEntity> collectPokemonDataById(int id) =>
      _pokemonRepository.collectPokemonDataById(id);
}
