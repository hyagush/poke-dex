import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:poke_dex/src/core/services/loader/loader_service.dart';
import 'package:poke_dex/src/core/ui/theme/helpers/size_extensions.dart';
import 'package:poke_dex/src/core/ui/widgets/custom_snackbar.dart';
import 'package:poke_dex/src/views/welcome/controller/welcome_controller.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.controller});
  final WelcomeController controller;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _loaderService = Modular.get<LoaderService>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<WelcomeController, WelcomeState>(
      bloc: widget.controller,
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case WelcomeStatus.initial:
            _loaderService.hide();
            break;
          case WelcomeStatus.loading:
            _loaderService.show();
            break;
          case WelcomeStatus.success:
            _loaderService.hide();
            if (state.warningMessage != null) {
              CustomSnackbar.success(state.warningMessage!).show(context);
            }
            break;
          case WelcomeStatus.failure:
            _loaderService.hide();
            if (state.warningMessage != null) {
              CustomSnackbar.error(state.warningMessage!).show(context);
            }
            break;
        }
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  color: const Color.fromARGB(255, 226, 15, 0),
                  height: context.percentHeight(50),
                  child: Image.asset(
                    'assets/images/logo.png',
                    scale: 2,
                  ),
                ),
                SizedBox(
                  height: context.percentHeight(50),
                  child: Center(
                    child: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pokédex',
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiary,
                          ),
                        ),
                        Text(
                          'O melhor jeito de encontrar seu Pokémon!',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: () {
                            widget.controller.fetchPokemonList();
                          },
                          child: const Text('Começar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: Theme.of(context).colorScheme.tertiary,
              height: context.percentHeight(5),
            ),
            CircleAvatar(
              radius: context.percentWidth(15),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
            CircleAvatar(
              radius: context.percentWidth(13),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          ],
        ),
      ),
    );
  }
}
