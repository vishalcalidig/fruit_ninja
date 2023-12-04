import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:fruit_ninja_game/components/simple_button.dart';
import 'package:fruit_ninja_game/game.dart';

class PauseButton extends SimpleButton with HasGameReference<MainRouterGame> {
  PauseButton({VoidCallback? onPressed})
      : super(
            Path()
              ..moveTo(14, 10)
              ..lineTo(14, 30)
              ..moveTo(26, 10)
              ..lineTo(26, 30),
            position: Vector2(60, 10)) {
    super.action = onPressed ?? () => game.router.pushNamed('pause');
  }
}
