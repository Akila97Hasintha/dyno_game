
import 'package:dino_game/constraint.dart';
import 'package:dino_game/gameObject.dart';
import 'package:dino_game/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



  List<Sprite> dino = [
  Sprite()..imagePath = "assets/images/dino/dino_1.png"
  ..imageHeight = 94
  ..imageWidth = 88,
    Sprite()..imagePath = "assets/images/dino/dino_2.png"
      ..imageHeight = 94
      ..imageWidth = 88,
    Sprite()..imagePath = "assets/images/dino/dino_3.png"
      ..imageHeight = 94
      ..imageWidth = 88,
    Sprite()..imagePath = "assets/images/dino/dino_4.png"
      ..imageHeight = 94
      ..imageWidth = 88,
    Sprite()..imagePath = "assets/images/dino/dino_5.png"
      ..imageHeight = 94
      ..imageWidth = 88,
    Sprite()..imagePath = "assets/images/dino/dino_6.png"
      ..imageHeight = 94
      ..imageWidth = 88,];

  enum DinoState {
    jumping,
    running,
    dead,
  }
class Dino extends GameObject{
  late Sprite currentSprite = dino[0];
  double dispY = 0;
  double valY = 0;
  DinoState state = DinoState.running;
  @override
  Widget render() {
    return Image.asset(currentSprite.imagePath);

  }
  @override
  Rect getRect(Size screenSize, double runDistance) {
   return Rect.fromLTWH(
       screenSize.width /10,
       screenSize.height / 2- currentSprite.imageHeight - dispY,
       currentSprite.imageWidth.toDouble(),
       currentSprite.imageHeight.toDouble());
  }

  @override
  void update(Duration lastTime , Duration currentTime) {
      currentSprite = dino[(currentTime.inMicroseconds/100000).floor() %2 +2];

      double elapsedTimeSeconds = (currentTime - lastTime).inMicroseconds / 1000000;
      dispY += valY * elapsedTimeSeconds;
      if(dispY <= 0) {
        dispY = 0;
        valY = 0;
        state = DinoState.running;
      }else{
        valY -= GRAVITY_PASS * elapsedTimeSeconds;
      }

  }

  void jump(){
    if (state != DinoState.jumping){
      state = DinoState.jumping;
      valY = 800;
    }


  }

  void die(BuildContext context , Function() resetGame){
    currentSprite = dino[5];
    state = DinoState.dead;
    try {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Game Over', style: TextStyle(fontSize: 24.0,color: Colors.red)),
                  const SizedBox(height: 16.0),
                  const Text('You lost the game!', style: TextStyle(fontSize: 16.0,color: Colors.red)),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    child: const Text('Restart', style: TextStyle(fontSize: 16.0)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      resetGame();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    } catch (e) {
      print('Error: $e');
    }
  }

  
}