import 'dart:math';

import 'package:flame/game.dart';

class Utils {
  Utils._();

  static int getAngleOfTouchPoint({
    required Vector2 center,
    required double initAngle,
    required Vector2 touch,
  }) {
    final touchPoint = touch - center;

    double angle = atan2(touchPoint.y, touchPoint.x);

    angle -= initAngle;
    angle %= 2 * pi;
    return radiansToDegress(angle).toInt();
  }

  static double radiansToDegress(double angle) {
    return angle * 180 / pi;
  }
}
