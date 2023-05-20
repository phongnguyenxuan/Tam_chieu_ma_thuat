import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shake_event/shake_event.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with ShakeHandler, SingleTickerProviderStateMixin {
  var dices = ["1", "2", "3", "4", "5", "6"];
  var randomDice1 = Random();
  var randomDice2 = Random();
  var randomDice3 = Random();
  late var dice1 = dices[randomDice1.nextInt(dices.length)];
  late var dice2 = dices[randomDice2.nextInt(dices.length)];
  late var dice3 = dices[randomDice3.nextInt(dices.length)];
  late int result1 = int.parse(dice1);
  late int result2 = int.parse(dice2);
  late int result3 = int.parse(dice3);
  bool isHiden = true;
  late AudioPlayer audioPlayer;
  AudioCache audioCache = new AudioCache();
  late int sum = result1 + result2 + result3;
  late double left;
  late double top;

  @override
  void initState() {
    left = 27;
    top = 180;
    audioPlayer = AudioPlayer();
    audioCache.prefix = "assets/sounds/";
    startListeningShake(
        10); //20 is the default threshold value for the shake event
    super.initState();
  }

  @override
  void dispose() {
    resetShakeListeners();
    super.dispose();
  }

  @override
  shakeEventListener() {
    //shake event
    setState(() {
      if (isHiden == true) {
        playsound();
        dice1 = dices[randomDice1.nextInt(dices.length)];
        dice2 = dices[randomDice2.nextInt(dices.length)];
        dice3 = dices[randomDice3.nextInt(dices.length)];
        result1 = int.parse(dice1);
        result2 = int.parse(dice2);
        result3 = int.parse(dice3);
        sum = result1 + result2 + result3;
      }
    });
    return super.shakeEventListener();
  }

  void playsound() {
    try {
      audioPlayer.play(
        AssetSource("sounds/shakingsound.mp3"),
        position: Duration(seconds: 0),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Size.infinite.width,
            height: Size.infinite.height,
            child: Image.asset(
              "assets/images/chieucoi.jpg",
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: Size.infinite.width,
            height: Size.infinite.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Visibility(
                        visible: !isHiden,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(
                              sum > 10 ? "Tài" : "Xỉu",
                              style: TextStyle(
                                  color: sum > 10
                                      ? Colors.greenAccent
                                      : Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          isHiden ? "" : sum.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 320,
                          height: 320,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black54,
                                    offset: Offset(6, 6),
                                    blurRadius: 20,
                                    spreadRadius: 3)
                              ]),
                          child: const Image(
                            image: AssetImage("assets/images/bowl.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Dice(120, 290, 2, dice1),
                      Dice(158, 340, 4, dice2),
                      Dice(200, 300, 25, dice3),
                      Positioned(
                        left: left,
                        top: top,
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            setState(() {
                              top = details.localPosition.dy;
                              if (top < 180) {
                                top = 180;
                              }
                              if (top >= 375) {
                                top = 375;
                              }
                              debugPrint("DX: $top");
                            });
                            if (top >= 365) {
                              setState(() {
                                isHiden = false;
                              });
                            }
                            if (top == 180) {
                              setState(() {
                                isHiden = true;
                              });
                            }
                          },
                          onVerticalDragEnd: (details) {
                            Future.delayed(Duration(seconds: 2), () {
                              if (top >= 365) {
                                setState(() {
                                  top = 180;
                                  isHiden = true;
                                });
                              }
                            });
                          },
                          child: Container(
                            width: 330,
                            height: 330,
                            child: const Image(
                              image: AssetImage("assets/images/plate.png"),
                              alignment: Alignment.center,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Positioned Dice(double left, double top, double angle, String dice) {
    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black54,
                offset: Offset(4, 4),
                blurRadius: 35,
                spreadRadius: 1)
          ]),
          child: ClipRRect(
            child: Image(
              image: getimage(dice),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider getimage(String img) {
    return AssetImage("assets/images/" + img + ".png");
  }
}
