import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart' hide Game;
import 'package:flutter/material.dart';
import 'package:fruit_ninja_game/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBnuFeocTyZ0CS0VUBy6kKPpLehinor04k",
      appId: "1:509823368934:web:2c17101922db9610870527",
      messagingSenderId: "509823368934",
      projectId: "fruit-ninja-game",
    ),
  );
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(GameWidget(game: MainRouterGame()));
}
