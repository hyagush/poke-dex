import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:poke_dex/app_module.dart';
import 'package:poke_dex/src/domain/usecases/pokemon_usecase.dart';

part 'welcome_state.dart';

class WelcomeController extends Cubit<WelcomeState> {
  final PokemonUsecase _pokemonUsecase;
  WelcomeController({required PokemonUsecase pokemonUsecase})
    : _pokemonUsecase = pokemonUsecase,
      super(const WelcomeState.initial());

  Future<void> fetchPokemonList() async {
    try {
      emit(state.copyWith(status: WelcomeStatus.loading));
      await _pokemonUsecase.fetchPokemonList();
      emit(
        state.copyWith(
          status: WelcomeStatus.success,
          warningMessage: null,
        ),
      );

      Modular.to.pushReplacementNamed(AppModule.home);
    } catch (e) {
      emit(
        state.copyWith(
          status: WelcomeStatus.failure,
          warningMessage: 'Erro ao carregar a lista de pokémons',
        ),
      );
    }
  }
}
