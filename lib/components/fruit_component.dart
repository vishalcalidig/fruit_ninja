import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart' as composition;
import 'package:fruit_ninja_game/config/app_config.dart';
import 'package:fruit_ninja_game/config/utils.dart';
import 'package:fruit_ninja_game/models/fruit_model.dart';
import 'package:fruit_ninja_game/routes/game_page.dart';

class FruitComponent extends SpriteComponent {
  Vector2 velocity;
  final Vector2 pageSize;
  final double acceleration;
  final FruitModel fruit;
  final composition.Image image;
  late Vector2 _initPosition;
  bool _canDragOnShape = false;
  GamePage parentComponent;
  bool divided;

  FruitComponent(
    this.parentComponent,
    Vector2 p, {
    Vector2? size,
    required this.velocity,
    required this.acceleration,
    required this.pageSize,
    required this.image,
    required this.fruit,
    double? angle,
    Anchor? anchor,
    this.divided = false,
  }) : super(
          sprite: Sprite(image),
          position: p,
          size: size,
          anchor: anchor ?? Anchor.center,
          angle: angle,
        ) {
    _initPosition = p;
    _canDragOnShape = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_initPosition.distanceTo(position) > 60) {
      _canDragOnShape = true;
    }
    angle += 0.5 * dt;
    angle %= 2 * pi;

    position += Vector2(
        velocity.x, -(velocity.y * dt - 0.5 * AppConfig.gravity * dt * dt));

    velocity.y += (AppConfig.accleration + AppConfig.gravity) * dt;

    if ((position.y - AppConfig.objSize) > pageSize.y) {
      removeFromParent();

      if (!divided && !fruit.isBomb) {
        parentComponent.addMistake();
      }
    }
  }

  void touchAtPoint(Vector2 vector2) {
    if (divided && !_canDragOnShape) {
      return;
    }
    if (fruit.isBomb) {
      parentComponent.gameOver();
      return;
    }

    final a = Utils.getAngleOfTouchPoint(
      center: position,
      initAngle: angle,
      touch: vector2,
    );
    if (a < 45 || (a > 135 && a < 225) || a > 315) {
      final dividedImage1 = composition.ImageComposition()
            ..add(image, Vector2(0, 0),
                source: Rect.fromLTWH(
                    0, 0, image.width.toDouble(), image.height / 2)),
          dividedImage2 = composition.ImageComposition()
            ..add(image, Vector2(0, 0),
                source: Rect.fromLTWH(
                    0, 0, image.width.toDouble(), image.height / 2));

      parentComponent.addAll([
        FruitComponent(
          parentComponent,
          center - Vector2(size.x / 2 * cos(angle), size.x / 2 * sin(angle)),
          image: dividedImage2.composeSync(),
          acceleration: acceleration,
          pageSize: pageSize,
          divided: true,
          fruit: fruit,
          velocity: Vector2(velocity.x - 2, velocity.y),
          size: Vector2(size.x, size.y / 2),
          angle: angle,
          anchor: Anchor.topLeft,
        ),
        FruitComponent(
          parentComponent,
          center +
              Vector2(size.x / 4 * cos(angle + 3 * pi / 2),
                  size.x / 4 * sin(angle + 3 * pi / 2)),
          size: Vector2(size.x, size.y / 2),
          angle: angle,
          anchor: Anchor.center,
          fruit: fruit,
          image: dividedImage1.composeSync(),
          acceleration: acceleration,
          velocity: Vector2(velocity.x + 2, velocity.y),
          pageSize: pageSize,
          divided: true,
        ),
      ]);
    } else {
      final dividedImage1 = composition.ImageComposition()
            ..add(image, Vector2(0, 0),
                source: Rect.fromLTWH(
                    0, 0, image.width / 2, image.height.toDouble())),
          dividedImage2 = composition.ImageComposition()
            ..add(image, Vector2(0, 0),
                source: Rect.fromLTWH(image.width / 2, 0, image.width / 2,
                    image.height.toDouble()));
      parentComponent.addAll([
        FruitComponent(
          parentComponent,
          center - Vector2(size.x / 4 * cos(angle), size.x / 4 * sin(angle)),
          size: Vector2(size.x / 2, size.y),
          angle: angle,
          anchor: Anchor.center,
          image: dividedImage1.composeSync(),
          fruit: fruit,
          acceleration: acceleration,
          velocity: Vector2(velocity.x - 2, velocity.y),
          pageSize: pageSize,
          divided: true,
        ),
        FruitComponent(
          parentComponent,
          center +
              Vector2(size.x / 2 * cos(angle + 3 * pi / 2),
                  size.x / 2 * sin(angle + 3 * pi / 2)),
          size: Vector2(size.x / 2, size.y),
          angle: angle,
          anchor: Anchor.topLeft,
          image: dividedImage2.composeSync(),
          fruit: fruit,
          acceleration: acceleration,
          velocity: Vector2(velocity.x + 2, velocity.y),
          pageSize: pageSize,
          divided: true,
        ),
      ]);
    }
    parentComponent.addScore();

    removeFromParent();
  }
}
