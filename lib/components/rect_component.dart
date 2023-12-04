import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:fruit_ninja_game/config/app_config.dart';
import 'package:fruit_ninja_game/config/utils.dart';

class RectComponent extends RectangleComponent {
  Vector2 velocity;
  final Vector2 pageSize;
  Vector2? touchPoint1, touchPoint2;

  RectComponent(
    Vector2 position, {
    required this.pageSize,
    required this.velocity,
  }) : super(
          size: AppConfig.shapeSize,
          position: position,
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);

    angle += 0.5 * dt;
    angle %= 2 * pi;

    position +=
        Vector2(0, -(velocity.y * dt - 0.5 * AppConfig.gravity * dt * dt));

    velocity.y += (AppConfig.accleration + AppConfig.gravity) * dt;

    if ((position.y - AppConfig.objSize) > pageSize.y) {
      removeFromParent();
    }
  }

  void touchAtPoint(Vector2 vector2) {
    final a = Utils.getAngleOfTouchPoint(
      center: position,
      initAngle: angle,
      touch: vector2,
    );
    if (a < 45 || (a > 135 && a < 225) || a > 315) {
      findGame()?.addAll([
        RectangleComponent(
          size: Vector2(size.x, size.y / 2),
          position: center -
              Vector2(size.x / 2 * cos(angle), size.x / 2 * sin(angle)),
          angle: angle,
          anchor: Anchor.topLeft,
          paint: Paint()..color = Colors.red,
        ),
        RectangleComponent(
          size: Vector2(size.x, size.y / 2),
          position: center +
              Vector2(size.x / 4 * cos(angle + 3 * pi / 2),
                  size.x / 4 * sin(angle + 3 * pi / 2)),
          angle: angle,
          anchor: Anchor.center,
          paint: Paint()..color = Colors.blue,
        ),
      ]);
    } else {
      findGame()?.addAll([
        RectangleComponent(
          size: Vector2(size.x / 2, size.y),
          position: center -
              Vector2(size.x / 4 * cos(angle), size.x / 4 * sin(angle)),
          angle: angle,
          anchor: Anchor.center,
          paint: Paint()..color = Colors.red,
        ),
        RectangleComponent(
          size: Vector2(size.x / 2, size.y),
          position: center +
              Vector2(size.x / 2 * cos(angle + 3 * pi / 2),
                  size.x / 2 * sin(angle + 3 * pi / 2)),
          angle: angle,
          anchor: Anchor.topLeft,
          paint: Paint()..color = Colors.blue,
        ),
      ]);

      removeFromParent();
    }
  }
}
