import 'package:flutter_modular/flutter_modular.dart';
import 'package:poke_dex/src/core/services/storage/storage_service.dart';
import 'package:poke_dex/src/data/repositories/pokemon_repository_impl.dart';
import 'package:poke_dex/src/data/sources/pokemon_source.dart';
import 'package:poke_dex/src/domain/repositories/pokemon_repository.dart';
import 'package:poke_dex/src/domain/usecases/pokemon_usecase.dart';
import 'package:poke_dex/src/views/home/controller/home_controller.dart';
import 'package:poke_dex/src/views/home/home_page.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<PokemonRepository>(
      () => PokemonRepositoryImpl(
        pokemonSource: Modular.get<PokemonSource>(),
        storage: Modular.get<StorageService>(),
      ),
    );
    i.addLazySingleton<PokemonUsecase>(() => PokemonUsecase(i.get<PokemonRepository>()));
    i.addLazySingleton(HomeController.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => HomePage(controller: Modular.get<HomeController>()),
    );
  }
}
