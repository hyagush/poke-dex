import 'package:poke_dex/src/core/services/network/http_service.dart';
import 'package:poke_dex/src/data/sources/pokemon_source.dart';

class PokemonSourceImpl implements PokemonSource {
  final HttpService httpService;

  PokemonSourceImpl(this.httpService);

  static const _endpointPokemonList = '/pokemon-species';
  static const _endpointPokemonData = '/pokemon/:id';

  @override
  Future<Map<String, dynamic>?> fetchPokemonList() async {
    try {
      final response = await httpService.unauth().get(
        _endpointPokemonList,
        queryParameters: {'offset': 0, 'limit': 9999},
      );
      if (response.statusCode == 200) return response.data;
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> collectPokemonDataById(int id) async {
    try {
      final response = await httpService.unauth().get(
        _endpointPokemonData.replaceAll(':id', id.toString()),
      );
      if (response.statusCode == 200) return response.data;
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
