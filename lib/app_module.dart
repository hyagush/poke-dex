import 'package:flutter_modular/flutter_modular.dart';
import 'package:poke_dex/src/core/services/loader/loader_service.dart';
import 'package:poke_dex/src/core/services/network/http_service.dart';
import 'package:poke_dex/src/core/services/network/http_service_impl.dart';
import 'package:poke_dex/src/core/services/storage/storage_service.dart';
import 'package:poke_dex/src/core/services/storage/storage_service_impl.dart';
import 'package:poke_dex/src/core/ui/theme/app_theme.dart';
import 'package:poke_dex/src/data/sources/pokemon_source.dart';
import 'package:poke_dex/src/data/sources/pokemon_source_impl.dart';
import 'package:poke_dex/src/views/home/home_module.dart';
import 'package:poke_dex/src/views/welcome/welcome_module.dart';

class AppModule extends Module {
  static const welcome = '/';
  static const home = '/home/';

  @override
  void binds(i) {
    i.addLazySingleton<AppTheme>(AppTheme.new);
    i.addLazySingleton<HttpService>(HttpServiceImpl.new);
    i.addLazySingleton<LoaderService>(LoaderService.new);
    i.addLazySingleton<StorageService>(StorageServiceImpl.new);
    i.addLazySingleton<PokemonSource>(() => PokemonSourceImpl(Modular.get()));
  }

  @override
  void routes(r) {
    r.module(welcome, module: WelcomeModule());
    r.module(home, module: HomeModule());
  }
}
