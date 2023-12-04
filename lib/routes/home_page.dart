import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:fruit_ninja_game/components/rounded_button.dart';
import 'package:fruit_ninja_game/game.dart';

class HomePage extends Component with HasGameReference<MainRouterGame> {
  late final RoundedButton _button1;

  @override
  void onLoad() {
    super.onLoad();
    add(
      _button1 = RoundedButton(
          text: 'Start Game',
          onPressed: () {
            game.router.pushNamed('game-page');
          },
          color: Colors.indigo,
          borderColor: Colors.white),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    //button in center of page
    _button1.position = size / 2;
  }
}
