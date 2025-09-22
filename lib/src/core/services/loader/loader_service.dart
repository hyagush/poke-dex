import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:poke_dex/src/core/ui/theme/helpers/size_extensions.dart';

class _SpinningLoader extends StatefulWidget {
  @override
  State<_SpinningLoader> createState() => _SpinningLoaderState();
}

class _SpinningLoaderState extends State<_SpinningLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.easeIn,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        Positioned(
          top: context.percentHeight(50) - 55,
          child: Image.asset(
            'assets/images/logo.png',
            width: context.percentWidth(20),
          ),
        ),
        RotationTransition(
          turns: _controller,
          child: Image.asset(
            'assets/images/pokeball.png',
            width: context.percentWidth(10),
          ),
        ),
        Positioned(
          top: context.percentHeight(50) + 20,
          child: Material(
            color: Colors.transparent,
            child: Text(
              'Carregando...',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ],
    );
  }
}

class LoaderService {
  var _isOpen = false;

  void show() {
    if (!_isOpen) {
      _isOpen = true;
      final context = Modular.routerDelegate.navigatorKey.currentContext;
      if (context != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: false,
          builder: (context) {
            return _SpinningLoader();
          },
        );
      }
    }
  }

  void hide() {
    if (_isOpen) {
      _isOpen = false;
      Modular.to.pop();
    }
  }
}
