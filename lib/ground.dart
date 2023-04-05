

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dino_game/gameObject.dart';
import 'package:dino_game/sprite.dart';


import 'constraint.dart';

Sprite groundSprite = Sprite()
..imagePath = "assets/images/ground.png"
..imageWidth = 2399
..imageHeight = 24;

class Ground extends GameObject{


  late final Offset worldLocation;

  Ground({required this.worldLocation}) ;
  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * WORLD_TO_PIXEL_RATIO,
      screenSize.height / 2 -groundSprite.imageHeight,
      groundSprite.imageWidth.toDouble(),
      groundSprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(groundSprite.imagePath);
  }

}