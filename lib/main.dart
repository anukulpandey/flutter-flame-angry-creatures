import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    GameWidget(game: MyGame())
  );
}

class MyGame extends Forge2DGame{
@override
  FutureOr<void> onLoad() async{
    await super.onLoad();
    add(Player());
  }
}

//Now the problem was that the player was only falling , so we need to add a ground
class Ground extends BodyComponent{
  final Vector2 gameSize;
  
  //constructor
  Ground(this.gameSize);

  @override
  Body createBody() {
    Shape shape = EdgeShape()..set(Vector2(0, gameSize.y * 0.9),Vector2(gameSize.x,gameSize.y * 0.9) );
    BodyDef bodyDef = BodyDef(userData: this,position: Vector2.zero());
    FixtureDef fixtureDef = FixtureDef(shape,friction: 0.3);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
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