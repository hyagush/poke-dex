import 'package:flutter_modular/flutter_modular.dart';
import 'package:poke_dex/src/data/repositories/pokemon_repository_impl.dart';
import 'package:poke_dex/src/data/sources/pokemon_source.dart';
import 'package:poke_dex/src/domain/repositories/pokemon_repository.dart';
import 'package:poke_dex/src/domain/usecases/pokemon_usecase.dart';
import 'package:poke_dex/src/views/welcome/controller/welcome_controller.dart';
import 'package:poke_dex/src/views/welcome/welcome_page.dart';

class WelcomeModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<PokemonRepository>(
      () => PokemonRepositoryImpl(Modular.get<PokemonSource>()),
    );
    i.addLazySingleton<PokemonUsecase>(() => PokemonUsecase(i.get<PokemonRepository>()));
    i.addLazySingleton(WelcomeController.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => WelcomePage(controller: Modular.get<WelcomeController>()),
    );
  }
}
