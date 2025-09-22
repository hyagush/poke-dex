import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:poke_dex/src/core/services/loader/loader_service.dart';
import 'package:poke_dex/src/core/ui/theme/helpers/size_extensions.dart';
import 'package:poke_dex/src/core/ui/widgets/custom_snackbar.dart';
import 'package:poke_dex/src/views/home/controller/home_controller.dart';
import 'package:poke_dex/src/views/home/widgets/screen_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.controller});
  final HomeController controller;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _loaderService = Modular.get<LoaderService>();

  @override
  void initState() {
    super.initState();
    widget.controller.fetchPokemonList();
    widget.controller.fetchPokemonDetails(widget.controller.state.pokemonList?.first.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeController, HomeState>(
      bloc: widget.controller,
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case HomeStatus.initial:
            _loaderService.hide();
            break;
          case HomeStatus.loading:
            _loaderService.show();
            break;
          case HomeStatus.success:
            _loaderService.hide();
            if (state.warningMessage != null) {
              CustomSnackbar.success(state.warningMessage!).show(context);
            }
            break;
          case HomeStatus.failure:
            _loaderService.hide();
            if (state.warningMessage != null) {
              CustomSnackbar.error(state.warningMessage!).show(context);
            }
            break;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: BlocBuilder<HomeController, HomeState>(
          bloc: widget.controller,
          builder: (context, state) {
            final pokemonList = state.pokemonList;
            final selectedPokemon = state.selectedPokemon;

            final isFirst = selectedPokemon?.id == pokemonList?.first.id;
            final isLast = selectedPokemon?.id == pokemonList?.last.id;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bem vindo(a) a PokéDex!',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: context.percentWidth(80),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Procure pelo nome',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ScreenWidget(
                    pokemon: selectedPokemon,
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 30,
                    children: [
                      ElevatedButton(
                        onPressed: isFirst
                            ? null
                            : () {
                                final selectedPokemonId = selectedPokemon?.id ?? 0;
                                widget.controller.fetchPokemonDetails(selectedPokemonId - 1);
                              },
                        child: Row(
                          children: [
                            RotatedBox(
                              quarterTurns: 2,
                              child: Icon(Icons.forward),
                            ),
                            const SizedBox(width: 5),
                            const Text('Anterior'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isLast
                            ? null
                            : () {
                                final selectedPokemonId = selectedPokemon?.id ?? 0;
                                widget.controller.fetchPokemonDetails(selectedPokemonId + 1);
                              },
                        child: Row(
                          children: [
                            const Text('Próximo'),
                            const SizedBox(width: 5),
                            Icon(Icons.forward),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
