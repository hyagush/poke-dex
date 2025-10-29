// Crie o Mock para a dependência
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poke_dex/src/domain/entities/pokemon_entity.dart';
import 'package:poke_dex/src/domain/usecases/pokemon_usecase.dart';
import 'package:poke_dex/src/views/home/controller/home_controller.dart';

class MockPokemonUsecase extends Mock implements PokemonUsecase {}

void main() {
  late HomeController homeController;
  late MockPokemonUsecase mockPokemonUsecase;

  final tPokemonEntityList = [
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

  final tException = Exception('Falha na API');

  setUp(() {
    mockPokemonUsecase = MockPokemonUsecase();
    homeController = HomeController(pokemonUsecase: mockPokemonUsecase);
  });

  test('o estado inicial deve ser PokemonInitial', () {
    expect(homeController.state, const HomeState.initial());
  });

  group('fetchPokemonList', () {
    // CENÁRIO DE SUCESSO
    blocTest<HomeController, HomeState>(
      'deve emitir [PokemonLoading, PokemonLoaded] quando a busca for bem-sucedida',
      build: () {
        // Arrange: Diga ao mock como se comportar
        when(
          () => mockPokemonUsecase.fetchPokemonList(),
        ).thenAnswer((_) async => tPokemonEntityList);
        return homeController;
      },
      act: (cubit) => cubit.fetchPokemonList(), // Act: Chame o método
      expect: () => [
        // Assert: Verifique a sequência de estados
        isA<PokemonLoading>(),
        isA<PokemonLoaded>(),
      ],
      verify: (_) {
        // Assert Extra: Verifique se o usecase foi chamado
        verify(() => mockPokemonUsecase.fetchPokemonList()).called(1);
      },
    );

    // CENÁRIO DE FALHA
    blocTest<PokemonCubit, PokemonState>(
      'deve emitir [PokemonLoading, PokemonError] quando a busca falhar',
      build: () {
        // Arrange: Diga ao mock para lançar um erro
        when(() => mockPokemonUsecase.fetchPokemonList()).thenThrow(tException);
        return homeController;
      },
      act: (cubit) => cubit.fetchPokemonList(), // Act
      expect: () => [
        // Assert
        isA<PokemonLoading>(),
        isA<PokemonError>(),
      ],
      verify: (_) {
        // Assert Extra
        verify(() => mockPokemonUsecase.fetchPokemonList()).called(1);
      },
    );
  });
}
