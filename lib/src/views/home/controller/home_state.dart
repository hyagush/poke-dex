part of 'home_controller.dart';

enum HomeStatus { initial, failure, success, loading }

class HomeState extends Equatable {
  final HomeStatus status;
  final String? warningMessage;
  final List<PokemonModel>? pokemonList;
  final PokemonModel? selectedPokemon;

  const HomeState._({
    required this.status,
    this.warningMessage,
    this.pokemonList,
    this.selectedPokemon,
  });

  const HomeState.initial() : this._(status: HomeStatus.initial);

  @override
  List<Object?> get props => [status, warningMessage, pokemonList, selectedPokemon];

  HomeState copyWith({
    HomeStatus? status,
    String? warningMessage,
    List<PokemonModel>? pokemonList,
    PokemonModel? selectedPokemon,
  }) {
    return HomeState._(
      status: status ?? this.status,
      warningMessage: warningMessage,
      pokemonList: pokemonList ?? this.pokemonList,
      selectedPokemon: selectedPokemon ?? this.selectedPokemon,
    );
  }
}
