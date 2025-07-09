import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';
import 'package:game_jet/components/explosion.dart';
import 'package:game_jet/my_game.dart';

class Asteroid extends SpriteComponent with HasGameReference<MyGame>{
  final Random _random = Random(); 
  static const double _maxsize = 120;
  late Vector2 _velocity;
  final Vector2 _originalVelocity = Vector2.zero();
  late double _spinSpeed;
  final double _maxhealth = 3;
  late double _health;
  bool _isKnockedback = false;

  Asteroid({required super.position, double size = 80})
  : super(size: Vector2.all(size), 
  anchor: Anchor.center,
  priority: -1,
  ){
    _velocity = _generateVelocity();
    _originalVelocity.setFrom(_velocity);
    _spinSpeed = _random.nextDouble() * 1.5 - 0.75;
    _health = size / _maxsize * _maxhealth;

    add(CircleHitbox(collisionType: CollisionType.passive));

  }

  @override
  FutureOr<void> onLoad() async{
    final int imageNum = _random.nextInt(3) +1;
    sprite = await game.loadSprite('asteroid$imageNum.png');
    return super.onLoad();
  }
  @override
  void update(double dt) {
    position += _velocity*dt;
    _handleScreenBounds();

    angle += _spinSpeed * dt;

   
    super.update(dt);
  }

  Vector2 _generateVelocity() {
    final double forceFactor = _maxsize / size.x;

    return Vector2(
      _random.nextDouble() *120 -60,
      100 + _random.nextDouble() *50,
      ) *forceFactor;
  }

  void _handleScreenBounds(){
     //  remove the asteroid from the game if it goes below the bottom 
    if (position.y > game.size.y + size.y/2){
      removeFromParent();
    }

    // perform wraparound if the asteroid goes over the left or right edge 
    final double screenWidth = game.size.x;
    if(position.x < -size.x/2){
      position.x = screenWidth + size.x /2;
    }
    else if (position.x > screenWidth + size.x/2){
      position.x = -size.x /2;
    }
  }

  void takeDamage() {
    game.audioManager.playSound('hit');
    _health--;

    if(_health <= 0){
      game.incrementScore(2);
      removeFromParent();
      _createExplosion();
      _splitAsteroid();
    }
    else{
      game.incrementScore(1);
      _flashWhite();
      _applyKnockback();
    }
  }

  void _flashWhite(){
    final ColorEffect flashEffect = ColorEffect(
      const Color.fromARGB(255, 244, 19, 19), 
      EffectController(
        duration: 0.2,
        alternate: true,
        curve: Curves.easeInOut,
      ),
      );
      add(flashEffect);
  }

  void _applyKnockback(){
    if (_isKnockedback) return;

    _isKnockedback = true;
    _velocity.setZero();
    final MoveByEffect knockbackEffect = MoveByEffect(Vector2(0, -20), 
    EffectController(
      duration: 0.1,

    ),
    onComplete: _restoreVelocity,
    );
    add(knockbackEffect);

  }

  void _restoreVelocity(){
    _velocity.setFrom(_originalVelocity);
    _isKnockedback = false;
  }

  void _createExplosion(){
    final Explosion explosion = Explosion(position: position.clone(),
    explosionSize: size.x, 
    explosionType: ExplosionType.dust);
    game.add(explosion);
  }

  void _splitAsteroid(){
    if (size.x <= _maxsize /3)return;
    for(int i =0; i<1; i++){
      final Asteroid fragment = Asteroid(position: position.clone(),
      size: size.x - _maxsize/3);
      game.add(fragment);
    }
  }
} 