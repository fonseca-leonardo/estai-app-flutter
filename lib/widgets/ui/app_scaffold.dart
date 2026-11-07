import 'package:flutter/material.dart';

import 'background_scrim.dart';

/// Scaffold das telas logadas fora da marina: mesmo uso do [Scaffold], mas com
/// o `bg.png` e o véu escuro atrás de tudo (inclusive da AppBar translúcida).
/// O fundo do Scaffold é sempre transparente; por isso `backgroundColor` não
/// existe aqui.
class AppScaffold extends StatelessWidget {
  static const String backgroundAsset = 'assets/images/bg.png';

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    @Deprecated('O fundo é a imagem; este parâmetro é ignorado.')
    Color? backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Colors.black),
        Image.asset(backgroundAsset, fit: BoxFit.cover, gaplessPlayback: true),
        const BackgroundScrim(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ],
    );
  }
}
