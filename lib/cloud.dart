

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dino_game/gameObject.dart';
import 'package:dino_game/sprite.dart';


import 'constraint.dart';

Sprite cloudSprite = Sprite()
  ..imagePath = "assets/images/ground.png"
  ..imageWidth = 92
  ..imageHeight = 30;

class Cloud extends GameObject{


  late final Offset worldLocation;

  Cloud({required this.worldLocation}) ;
  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * WORLD_TO_PIXEL_RATIO /4,
      screenSize.height/5  -cloudSprite.imageHeight - worldLocation.dy,
      cloudSprite.imageWidth.toDouble(),
      cloudSprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(cloudSprite.imagePath);
  }

}