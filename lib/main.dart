import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(
    GameWidget(game: MyGame())
  );
}

class MyGame extends Forge2DGame with HasTappables{
@override
  FutureOr<void> onLoad() async{
    await super.onLoad();
    Vector2 gameSize = screenToWorld(camera.viewport.effectiveSize); //now gamesize is converted to coordinate system for forge2d game
    add(SpriteComponent()
      ..sprite = await loadSprite('background.jpg')
      ..size = size
      );
    add(Ground(gameSize));
    add(Player());
  }
}

//Now the problem was that the player was only falling , so we need to add a ground
class Ground extends BodyComponent{
  final Vector2 gameSize;
  
  //constructor
  Ground(this.gameSize):super(renderBody: false);

  @override
  Body createBody() {
    Shape shape = EdgeShape()
    ..set(
      Vector2(0, gameSize.y * 0.86),
      Vector2(gameSize.x,gameSize.y * 0.86)
    ); //you can play with this by changing the coordinates of vectors it will form different lines
    BodyDef bodyDef = BodyDef(userData: this,position: Vector2.zero());
    FixtureDef fixtureDef = FixtureDef(shape,friction: 0.3);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Player extends BodyComponent with Tappable{
  @override
  Future<void> onLoad() async{
    add(SpriteComponent()..size=Vector2.all(6)..sprite=await gameRef.loadSprite('creature.gif')..anchor=Anchor.center);
    renderBody=false;
    await super.onLoad();
  }

  @override
  Body createBody() {
    Shape shape = CircleShape()..radius = 3;
    BodyDef bodyDef = BodyDef(position: Vector2(10,5),type: BodyType.dynamic); //this can interact with others
    FixtureDef fixtureDef = FixtureDef(shape,friction: 0.4,density: 1); // determines physical properties
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    body.applyLinearImpulse(Vector2(20, -15)*100);
    return false;
  }
}