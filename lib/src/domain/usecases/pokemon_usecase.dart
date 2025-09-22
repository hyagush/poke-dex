import 'package:poke_dex/src/domain/models/pokemon_model.dart';
import 'package:poke_dex/src/domain/repositories/pokemon_repository.dart';

class PokemonUsecase {
  final PokemonRepository _pokemonRepository;
  PokemonUsecase(this._pokemonRepository);

  Future<List<PokemonModel>> fetchPokemonList() => _pokemonRepository.fetchPokemonList();
  Future<PokemonModel> collectPokemonDataById(int id) =>
      _pokemonRepository.collectPokemonDataById(id);
}
