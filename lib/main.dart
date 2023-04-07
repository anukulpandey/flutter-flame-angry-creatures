import 'dart:async';
import 'dart:math';

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
  final List<String> obstacles = [
    'scala.gif',
    'evenidk.gif',
    'oldie.gif',
    'space-bear.gif',
    'blackie.gif',
    'coolbuck.gif',
    'purple-mole.gif',
    'space.gif',
    'cowboi.gif',
    'kingo.gif',
    'laso.gif'
  ];
@override
  FutureOr<void> onLoad() async{
    await super.onLoad();
    Vector2 gameSize = screenToWorld(camera.viewport.effectiveSize); //now gamesize is converted to coordinate system for forge2d game
    add(SpriteComponent()
      ..sprite = await loadSprite('background.png')
      ..size = size
      );
    add(Ground(gameSize));
    add(Player());
    add(Obstacle(Vector2(45,0), await loadSprite('scala.gif')));
    add(Obstacle(Vector2(53,6), await loadSprite('evenidk.gif')));
    add(Obstacle(Vector2(53,0), await loadSprite('oldie.gif')));
    add(Obstacle(Vector2(60,0), await loadSprite('space-bear.gif')));
    add(Obstacle(Vector2(60,6), await loadSprite('blackie.gif')));
    add(Obstacle(Vector2(60,12), await loadSprite('coolbuck.gif')));
    add(Obstacle(Vector2(60,18), await loadSprite('purple-mole.gif')));
    add(Obstacle(Vector2(65,0), await loadSprite('space.gif')));
    add(Obstacle(Vector2(70,0), await loadSprite('cowboi.gif')));
    add(Obstacle(Vector2(70,6), await loadSprite('kingo.gif')));
    add(Obstacle(Vector2(70,12), await loadSprite('laso.gif')));
    
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
      Vector2(0, gameSize.y * 0.90),
      Vector2(gameSize.x,gameSize.y * 0.90)
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
    body.applyLinearImpulse(Vector2(10, -10)*100);
    return false;
  }
}

class Obstacle extends BodyComponent{
  final Vector2 position;
  final Sprite sprite;

  Obstacle(this.position,this.sprite);

  @override
  Future<void> onLoad() async{
    add(SpriteComponent()..size=Vector2.all(6)..sprite=sprite..anchor=Anchor.center..flipHorizontally());
    renderBody=false;
    await super.onLoad();
  }

  @override
  Body createBody() {
    Shape shape = CircleShape()..radius=2;
    BodyDef bodyDef = BodyDef(userData: this,position: position,type: BodyType.dynamic);
    FixtureDef fixtureDef = FixtureDef(shape,friction: 0.2);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}