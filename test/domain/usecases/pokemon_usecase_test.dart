import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poke_dex/src/domain/entities/pokemon_entity.dart';
import 'package:poke_dex/src/domain/repositories/pokemon_repository.dart';
import 'package:poke_dex/src/domain/usecases/pokemon_usecase.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late PokemonUsecase pokemonUseCase;
  late MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    pokemonUseCase = PokemonUsecase(mockPokemonRepository);
  });

  final pokemonEntityList = [
    PokemonEntity(
      id: 1,
      name: 'bulbasaur',
      defaultArtwork: 'url/1.png',
      shinyArtwork: 'url/shiny/1.png',
    ),
    PokemonEntity(
      id: 2,
      name: 'ivysaur',
      defaultArtwork: 'url/2.png',
      shinyArtwork: 'url/shiny/2.png',
    ),
  ];

  group('fetchPokemonList', () {
    test('deve retornar uma lista de PokemonEntity quando chamado...', () async {
      // Arrange
      when(
        () => mockPokemonRepository.fetchPokemonList(),
      ).thenAnswer((_) async => pokemonEntityList);

      // Act
      final result = await pokemonUseCase.fetchPokemonList();

      // Assert
      expect(result, equals(pokemonEntityList));

      verify(() => mockPokemonRepository.fetchPokemonList()).called(1);
      verifyNoMoreInteractions(mockPokemonRepository);
    });

    test('deve lançar uma exceção quando o repositório falhar...', () async {
      // Arrange
      when(() => mockPokemonRepository.fetchPokemonList()).thenThrow(Exception('Falha na API'));

      // Act
      final call = pokemonUseCase.fetchPokemonList;

      // Assert
      expect(() => call(), throwsA(isA<Exception>()));

      verify(() => mockPokemonRepository.fetchPokemonList()).called(1);
      verifyNoMoreInteractions(mockPokemonRepository);
    });
  });
}
