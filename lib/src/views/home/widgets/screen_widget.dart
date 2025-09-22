import 'package:flutter/material.dart';
import 'package:poke_dex/src/core/ui/theme/helpers/size_extensions.dart';
import 'package:poke_dex/src/domain/models/pokemon_model.dart';

class ScreenWidget extends StatelessWidget {
  final PokemonModel? pokemon;
  const ScreenWidget({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: context.percentWidth(70),
          width: context.percentWidth(80),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            border: Border.all(width: 2, color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(6),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: context.percentHeight(2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 40,
                  children: [
                    Container(
                      height: context.percentHeight(2),
                      width: context.percentHeight(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(width: 2, color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                    Container(
                      height: context.percentHeight(2),
                      width: context.percentHeight(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(width: 2, color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  left: context.percentHeight(6),
                  bottom: context.percentHeight(1),
                  right: context.percentHeight(6),
                ),
                child: Row(
                  children: [
                    Container(
                      height: context.percentHeight(3.5),
                      width: context.percentHeight(3.5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(width: 2, color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                    Spacer(),
                    Column(
                      spacing: 4,
                      children: [
                        Container(
                          height: 2,
                          width: 30,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        Container(
                          height: 2,
                          width: 30,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        Container(
                          height: 2,
                          width: 30,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        Container(
                          height: 2,
                          width: 30,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: context.percentWidth(50),
          width: context.percentWidth(60),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: pokemon == null
              ? Center(
                  child: Text('Nenhum pokémon encontrado'),
                )
              : Column(
                  children: [
                    Image.network(
                      pokemon?.defaultArtwork ?? '',
                      width: context.percentWidth(35),
                    ),
                    Spacer(),
                    Text('N° ${pokemon?.id.toString().padLeft(4, '0')}'),
                    Text(
                      '${pokemon?.name[0].toUpperCase()}${pokemon?.name.substring(1)}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
