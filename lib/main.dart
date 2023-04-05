import 'dart:math';

import 'package:dino_game/cactus.dart';
import 'package:dino_game/dino.dart';
import 'package:dino_game/gameObject.dart';
import 'package:dino_game/ground.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'cloud.dart';

void main() {
  runApp(DevicePreview(

    builder: (context) =>  MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(title: 'Flutter Dino Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
Dino dino = Dino();
double runDistance = 0;
double runVelocity = 30;

late AnimationController worldController;
Duration lastUpdateCall = const Duration();





List<Cactus> cacti = [Cactus(worldLocation: const Offset(200,0))];
List<Ground> ground  = [
  Ground(worldLocation: const Offset(0,0)),
  Ground(worldLocation:  Offset(groundSprite.imageWidth / 10,0))
];

List<Cloud> clouds  = [
  Cloud(worldLocation: const Offset(100,20)),
  Cloud(worldLocation:  const Offset(200,10)),
  Cloud(worldLocation:  const Offset(350,-10))
];

@override
void initState(){
  super.initState();

  worldController = AnimationController(
      vsync: this,duration: const Duration(days: 99));
  worldController.addListener(_update);

  worldController.forward();
}

  void _die(){
    setState(() {
      worldController.stop();
      dino.die(context,resetGame);
      //resetGame();
    });
  }
void resetGame() {
  // Reset the game variables to their initial values
  dino = Dino();
  runDistance = 0;
  cacti = [Cactus(worldLocation: const Offset(200,0))];
  ground  = [
    Ground(worldLocation: const Offset(0,0)),
    Ground(worldLocation:  Offset(groundSprite.imageWidth / 10,0))
  ];
  clouds  = [
    Cloud(worldLocation: const Offset(100,20)),
    Cloud(worldLocation:  const Offset(200,10)),
    Cloud(worldLocation:  const Offset(350,-10))
  ];
  lastUpdateCall = const Duration();
  worldController.reset();
  worldController.forward();
}


_update() {
  dino.update(lastUpdateCall, worldController.lastElapsedDuration! );
  double elapsedTimeSeconds = (worldController.lastElapsedDuration! - lastUpdateCall).inMicroseconds / 999990;
  runDistance += runVelocity * elapsedTimeSeconds;

  Size screenSize = MediaQuery.of(context).size;

  Rect dinoRect = dino.getRect(screenSize, runDistance).deflate(5);
  
  for( Cactus cactus in cacti) {
    Rect obstacleRect = cactus.getRect(screenSize, runDistance).deflate(5);
    if(dinoRect.overlaps(obstacleRect)){
      _die();
    }

    if (obstacleRect.right < 0) {
      cacti.remove(cactus);
      cacti.add(
        Cactus(
            worldLocation:
            Offset(runDistance +
                Random().nextInt(100) + 50, 0)
        )
      );
    }
  }

  for(Ground groundlet in ground){
    if(groundlet.getRect(screenSize, runDistance).right < 0){
      setState(() {
        ground.remove(groundlet);
        ground.add(Ground(
            worldLocation: Offset(ground.last.worldLocation.dx + groundSprite.imageWidth / 10, 0)
        ));
      });
    }
  }

  for(Cloud cloud in clouds){
    if(cloud.getRect(screenSize, runDistance).right < 0){
      setState(() {
        clouds.remove(cloud);
        clouds.add(Cloud(
            worldLocation: Offset(
                clouds.last.worldLocation.dx + Random().nextInt(100) + 50
                , Random().nextInt(40) - 20.0
            )
        ));
      });
    }
  }


  lastUpdateCall = worldController.lastElapsedDuration!;
  if(worldController == null){
    print('error');
  }else{

  }
  lastUpdateCall = worldController.lastElapsedDuration!;
}
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];
    
    for (GameObject object in [...clouds,...ground,...cacti, dino]) {
      children.add(AnimatedBuilder(
          animation: worldController,
          builder: (context , _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );

          }
      ),);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          title: Text(widget.title),
        ),
        body:GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            dino.jump();
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: children,
          ),
        ),
             ),
    );
  }
}
