import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poke_dex/src/core/services/network/http_service.dart';
import 'package:poke_dex/src/data/sources/pokemon_source.dart';
import 'package:poke_dex/src/data/sources/pokemon_source_impl.dart';

class MockHttpService extends Mock implements HttpService {}

void main() {
  late PokemonSource pokemonSource;
  late MockHttpService mockHttpService;

  setUp(() {
    mockHttpService = MockHttpService();
    pokemonSource = PokemonSourceImpl(mockHttpService);
    when(() => mockHttpService.unauth()).thenReturn(mockHttpService);
  });

  final tPokemonListJson = jsonEncode({
    'results': [
      {
        'id': 1,
        'name': 'bulbasaur',
        'defaultArtwork': 'url/1.png',
        'shinyArtwork': 'url/shiny/1.png',
      },
      {
        'id': 2,
        'name': 'ivysaur',
        'defaultArtwork': 'url/2.png',
        'shinyArtwork': 'url/shiny/2.png',
      },
    ],
  });

  final tPokemonListMap = jsonDecode(tPokemonListJson);

  const tPathPokemonList = '/pokemon-species';

  group('fetchPokemonList', () {
    test('deve retornar um Map quando a chamada ao HttpService for bem-sucedida', () async {
      // Arrange
      when(
        () => mockHttpService.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          data: tPokemonListMap,
          statusCode: 200,
          requestOptions: RequestOptions(path: tPathPokemonList),
        ),
      );

      // Act
      final result = await pokemonSource.fetchPokemonList();

      // Assert
      expect(result, tPokemonListMap);

      verify(
        () => mockHttpService.get(
          tPathPokemonList,
          queryParameters: {
            'offset': 0,
            'limit': 9999,
          },
        ),
      ).called(1);
    });

    test('deve repassar a exceção quando a chamada ao HttpService falhar', () async {
      // Arrange
      when(
        () => mockHttpService.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(Exception('Erro de rede'));

      // Act
      final call = pokemonSource.fetchPokemonList;

      // Assert
      expect(() => call(), throwsA(isA<Exception>()));

      verify(
        () => mockHttpService.get(
          tPathPokemonList,
          queryParameters: {
            'offset': 0,
            'limit': 9999,
          },
        ),
      ).called(1);
    });
  });
}
