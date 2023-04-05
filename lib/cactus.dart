

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dino_game/constraint.dart';
import 'package:dino_game/gameObject.dart';
import 'package:dino_game/sprite.dart';

List<Sprite> CACTI = [
  Sprite()..imagePath = "assets/images/cacti/cacti_group.png"
    ..imageHeight = 104
    ..imageWidth = 100,
  Sprite()..imagePath = "assets/images/cacti/cacti_large_1.png"
    ..imageHeight = 50
    ..imageWidth = 100,
  Sprite()..imagePath = "assets/images/cacti/cacti_large_2.png"
    ..imageHeight = 98
    ..imageWidth = 100,
  Sprite()..imagePath = "assets/images/cacti/cacti_small_1.png"
    ..imageHeight = 34
    ..imageWidth = 70,
  Sprite()..imagePath = "assets/images/cacti/cacti_small_2.png"
    ..imageHeight = 68
    ..imageWidth = 70,
  Sprite()..imagePath = "assets/images/cacti/cacti_small_3.png"
    ..imageHeight = 107
    ..imageWidth = 70,];
class Cactus extends GameObject  {
  late final Sprite sprite;
  late final Offset worldLocation;

  Cactus ({required this.worldLocation}) : sprite = CACTI[Random().nextInt(CACTI.length)];
  @override
  Rect getRect(Size screenSize, double runDistance) {
      return Rect.fromLTWH(
          (worldLocation.dx - runDistance) * WORLD_TO_PIXEL_RATIO,
          screenSize.height / 2 -sprite.imageHeight,
          sprite.imageWidth.toDouble(),
          sprite.imageHeight.toDouble(),
      );
  }

  @override
  Widget render() {
    return Image.asset(sprite.imagePath);
  }
  
  
}