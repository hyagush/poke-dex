import 'dart:convert';
import 'package:poke_dex/src/core/services/storage/storage_service.dart';
import 'package:poke_dex/src/data/sources/pokemon_source.dart';
import 'package:poke_dex/src/data/models/pokemon_model.dart';
import 'package:poke_dex/src/domain/entities/pokemon_entity.dart';
import 'package:poke_dex/src/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl extends PokemonRepository {
  final PokemonSource _pokemonSource;
  final StorageService _storage;

  PokemonRepositoryImpl({required PokemonSource pokemonSource, required StorageService storage})
    : _pokemonSource = pokemonSource,
      _storage = storage;

  @override
  Future<List<PokemonEntity>> fetchPokemonList() async {
    final String storedData = await _storage.getData(key: 'pokemon_list');

    if (storedData.isNotEmpty) {
      final List<dynamic> storedList = jsonDecode(storedData);
      return storedList.map((item) => PokemonModel.fromMap(item).toEntity()).toList();
    }

    final result = await _pokemonSource.fetchPokemonList();
    if (result == null || result['results'] == null) {
      throw Exception('API retornou uma resposta inválida para a lista de Pokémons');
    }

    final List<dynamic> resultsList = result['results'];
    final pokemonList = resultsList.map((item) => PokemonModel.fromMap(item)).toList();

    if (pokemonList.isNotEmpty) {
      final listToStore = pokemonList.map((p) => p.toMap()).toList();
      await _storage.setData(
        key: 'pokemon_list',
        data: jsonEncode(listToStore),
      );
    }

    return pokemonList.map((model) => model.toEntity()).toList();
  }

  @override
  Future<PokemonEntity> collectPokemonDataById(int id) async {
    final detailKey = 'pokemon_detail_$id';

    final String storedDetails = await _storage.getData(key: detailKey);
    if (storedDetails.isNotEmpty) {
      final pokemonWithDetails = PokemonModel.fromMap(jsonDecode(storedDetails));
      if (pokemonWithDetails.defaultArtwork.isNotEmpty) {
        return pokemonWithDetails.toEntity();
      }
    }

    final result = await _pokemonSource.collectPokemonDataById(id);
    if (result == null) {
      throw Exception('API retornou nulo para o id $id');
    }

    final pokemonFromList =
        await _getPokemonFromMainList(id) ??
        PokemonModel(id: id, name: result['name'] ?? 'Unknown');

    final updatedPokemon = pokemonFromList.copyWith(
      defaultArtwork: result['sprites']['other']['official-artwork']['front_default'],
      shinyArtwork: result['sprites']['other']['official-artwork']['front_shiny'],
    );

    await _storage.setData(
      key: detailKey,
      data: jsonEncode(updatedPokemon.toMap()),
    );

    await _updateMainListInStorage(updatedPokemon);

    return updatedPokemon.toEntity();
  }

  Future<PokemonModel?> _getPokemonFromMainList(int id) async {
    final String storedData = await _storage.getData(key: 'pokemon_list');
    if (storedData.isEmpty) return null;

    final List<dynamic> storedList = jsonDecode(storedData);
    final pokemonMap = storedList.firstWhere(
      (item) => PokemonModel.fromMap(item).id == id,
      orElse: () => null,
    );

    return pokemonMap != null ? PokemonModel.fromMap(pokemonMap) : null;
  }

  Future<void> _updateMainListInStorage(PokemonModel pokemonToUpdate) async {
    final String storedData = await _storage.getData(key: 'pokemon_list');
    if (storedData.isEmpty) return;

    List<dynamic> storedList = jsonDecode(storedData);
    final index = storedList.indexWhere(
      (item) => PokemonModel.fromMap(item).id == pokemonToUpdate.id,
    );

    if (index != -1) {
      storedList[index] = pokemonToUpdate.toMap();
      await _storage.setData(
        key: 'pokemon_list',
        data: jsonEncode(storedList),
      );
    }
  }
}
