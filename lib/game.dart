import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:fruit_ninja_game/config/app_config.dart';
import 'package:fruit_ninja_game/models/fruit_model.dart';
import 'package:fruit_ninja_game/routes/game_over_page.dart';
import 'package:fruit_ninja_game/routes/game_page.dart';
import 'package:fruit_ninja_game/routes/home_page.dart';
import 'package:fruit_ninja_game/routes/pause_game_page.dart';

class MainRouterGame extends FlameGame with DragCallbacks {
  late final RouterComponent router;
  late double maxVerticalVelocity;

  final List<FruitModel> fruits = [
    FruitModel(
      image: 'apple.png',
    ),
    FruitModel(
      image: 'banana.png',
    ),
    FruitModel(
      image: 'kiwi.png',
    ),
    FruitModel(
      image: 'orange.png',
    ),
    FruitModel(
      image: 'watermelon.png',
    ),
    FruitModel(
      image: 'bomb.png',
      isBomb: true,
    ),
  ];

  @override
  void onLoad() async {
    await super.onLoad();

    for (final fruit in fruits) {
      await images.load(fruit.image);
    }

    addAll([
      ParallaxComponent(
          parallax: Parallax(
              [await ParallaxLayer.load(ParallaxImageData('bg.png'))])),
      router = RouterComponent(initialRoute: 'home', routes: {
        'home': Route(HomePage.new),
        'game-page': Route(GamePage.new),
        'pause': PauseRoute(),
        'game-over': GameOverRoute()
      }),
    ]);
  }


  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    getMaxVerticalVelocity(size);
  }

  void getMaxVerticalVelocity(Vector2 size) {
    maxVerticalVelocity = sqrt(2 *
        (AppConfig.gravity.abs() + AppConfig.accleration.abs()) *
        (size.y - AppConfig.objSize * 2));
  }
}
