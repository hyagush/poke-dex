import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_dex/src/domain/entities/pokemon_entity.dart';
import 'package:poke_dex/src/domain/usecases/pokemon_usecase.dart';

part 'home_state.dart';

class HomeController extends Cubit<HomeState> {
  final PokemonUsecase _pokemonUsecase;
  HomeController({required PokemonUsecase pokemonUsecase})
    : _pokemonUsecase = pokemonUsecase,
      super(const HomeState.initial());

  Future<void> fetchPokemonList() async {
    if (state.status == HomeStatus.loading) return;

    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final result = await _pokemonUsecase.fetchPokemonList();
      emit(
        state.copyWith(
          status: HomeStatus.success,
          pokemonList: result,
          warningMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          warningMessage: 'Erro ao carregar a lista de Pokémons',
        ),
      );
    }
  }

  Future<void> fetchPokemonDetails(int id) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));

      final updatedPokemon = await _pokemonUsecase.collectPokemonDataById(id);

      final updatedList = state.pokemonList?.map((pokemon) {
        return pokemon.id == id ? updatedPokemon : pokemon;
      }).toList();

      emit(
        state.copyWith(
          status: HomeStatus.success,
          selectedPokemon: updatedPokemon,
          pokemonList: updatedList,
          warningMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          warningMessage: 'Erro ao carregar os dados do pokémon #${id.toString().padLeft(4, '0')}',
        ),
      );
    }
  }

  void searchPokemon(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final maybeId = int.tryParse(trimmed);

    try {
      if (maybeId != null) {
        final found = state.pokemonList?.firstWhere((pokemon) => pokemon.id == maybeId);

        if (found != null) {
          fetchPokemonDetails(found.id);
          return;
        }
      } else {
        final lowered = trimmed.toLowerCase();
        final found = state.pokemonList?.firstWhere(
          (pokemon) => pokemon.name.toLowerCase().contains(lowered),
        );

        if (found != null) {
          fetchPokemonDetails(found.id);
          return;
        }
      }
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          warningMessage: 'Pokémon não encontrado',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          warningMessage: 'Pokémon não encontrado',
        ),
      );
    }
    emit(
      state.copyWith(
        status: HomeStatus.initial,
        warningMessage: null,
      ),
    );
  }
}
