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


class Player extends BodyComponent{
  @override
  Body createBody() {
    Shape shape = CircleShape()..radius = 3;
    BodyDef bodyDef = BodyDef(position: Vector2(10,5),type: BodyType.dynamic); //this can interact with others
    FixtureDef fixtureDef = FixtureDef(shape,friction: 0.4,density: 1); // determines physical properties
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}