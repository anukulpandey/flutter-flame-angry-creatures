import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    GameWidget(game: MyGame())
  );
}

class MyGame extends Forge2DGame{

}
