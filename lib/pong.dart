import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';

class Pong extends StatefulWidget {
  const Pong({super.key});

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> with TickerProviderStateMixin {
  late double width;
  late double height;
  late double posX;
  late double posY;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;

  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    posX = 0;
    posY = 0;
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = Tween<double>(begin: 0, end: 100).animate(animationController);
    animation.addListener(() {
      setState(() {
        posX++;
        posY++;
      });
    });
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      width = constraints.maxWidth;
      height = constraints.maxHeight;
      batWidth = width / 5;
      batHeight = height / 50;
      return Stack(
        children: [
          Positioned(top: posY, left: posX, child: const Ball()),
          Positioned(bottom: 0, child: Bat(batWidth, batHeight))
        ],
      );
    });
  }
}
