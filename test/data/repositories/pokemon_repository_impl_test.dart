// test/data/repositories/pokemon_repository_impl_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poke_dex/src/core/services/storage/storage_service.dart';
import 'package:poke_dex/src/data/models/pokemon_model.dart';
import 'package:poke_dex/src/data/repositories/pokemon_repository_impl.dart';
import 'package:poke_dex/src/data/sources/pokemon_source.dart';
import 'package:poke_dex/src/domain/entities/pokemon_entity.dart';
import 'package:poke_dex/src/domain/repositories/pokemon_repository.dart';

// 1. Crie os Mocks para as dependências
class MockPokemonDatasource extends Mock implements PokemonSource {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  late PokemonRepository repository;
  late MockPokemonDatasource mockPokemonSource;
  late MockStorageService mockStorage;

  setUp(() {
    mockPokemonSource = MockPokemonDatasource();
    mockStorage = MockStorageService();
    repository = PokemonRepositoryImpl(
      pokemonSource: mockPokemonSource,
      storage: mockStorage,
    );
  });

  final tPokemonModel = PokemonModel(
    id: 1,
    name: 'bulbasaur',
    defaultArtwork: 'url/1.png',
    shinyArtwork: 'url/shiny/1.png',
  );

  final tPokemonEntity = PokemonEntity(
    id: 1,
    name: 'Bulbasaur',
    defaultArtwork: 'url/1.png',
    shinyArtwork: 'url/shiny/1.png',
  );

  final tPokemonEntityList = [tPokemonEntity];

  final tPokemonJsonString = jsonEncode([tPokemonModel.toMap()]);

  group('fetchPokemonList', () {
    test('deve retornar a lista do cache quando houver dados disponíveis', () async {
      // Arrange
      when(
        () => mockStorage.getData(key: 'pokemon_list'),
      ).thenAnswer((_) async => tPokemonJsonString);

      // Act
      final result = await repository.fetchPokemonList();

      // Assert
      expect(result, tPokemonEntityList);

      verify(() => mockStorage.getData(key: 'pokemon_list')).called(1);
      verifyNever(() => mockPokemonSource.fetchPokemonList());
    });

    test('deve buscar da API e salvar no cache quando o cache estiver vazio', () async {
      // Arrange
      when(() => mockStorage.getData(key: any(named: 'key'))).thenAnswer((_) async => '');

      when(() => mockPokemonSource.fetchPokemonList()).thenAnswer(
        (_) async => {
          'results': [tPokemonModel.toMap()],
        },
      );

      when(
        () => mockStorage.setData(
          key: any(named: 'key'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.fetchPokemonList();

      // Assert
      expect(result, tPokemonEntityList);

      verify(() => mockStorage.getData(key: 'pokemon_list')).called(1);
      verify(() => mockPokemonSource.fetchPokemonList()).called(1);
      verify(() => mockStorage.setData(key: 'pokemon_list', data: tPokemonJsonString)).called(1);
    });

    test('deve lançar uma exceção quando o cache estiver vazio e a API falhar', () async {
      // Arrange
      when(() => mockStorage.getData(key: any(named: 'key'))).thenAnswer((_) async => '');

      when(() => mockPokemonSource.fetchPokemonList()).thenThrow(Exception('Erro na API'));

      // Act
      final call = repository.fetchPokemonList();

      // Assert
      await expectLater(() => call, throwsA(isA<Exception>()));

      verify(() => mockStorage.getData(key: 'pokemon_list')).called(1);
      verify(() => mockPokemonSource.fetchPokemonList()).called(1);
      verifyNever(
        () => mockStorage.setData(
          key: any(named: 'key'),
          data: any(named: 'data'),
        ),
      );
    });
  });
}
