import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';
import 'dart:math';

enum Direction { up, down, left, right }

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
  final double speed = 5;
  double randX = 1;
  double randY = 1;

  late Animation<double> animation;
  late AnimationController animationController;

  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  void checkBoundaries() {
    double diameter = 50;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }

    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      //check if the bat is here, otherwise loose
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
      } else {
        animationController.stop();
        dispose();
      }
    }

    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  @override
  void initState() {
    posX = 0;
    posY = 0;
    animationController = AnimationController(
        vsync: this, duration: const Duration(minutes: 10000));
    animation = Tween<double>(begin: 0, end: 100).animate(animationController);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += ((randX * speed).round())
            : posX -= ((randX * speed).round());
        (vDir == Direction.down)
            ? posY += ((randY * speed).round())
            : posY -= ((randY * speed).round());
      });
      checkBoundaries();
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
          Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) => moveBat(details),
                child: Bat(batWidth, batHeight),
              ))
        ],
      );
    });
  }

  void moveBat(DragUpdateDetails details) {
    safeSetState(() {
      batPosition += details.delta.dx;
    });
  }

  void safeSetState(Function fn) {
    if (mounted && animationController.isAnimating) {
      setState(() {
        fn();
      });
    }
  }

  double randomNumber() {
    // Random number between 0.5 and 1.5
    var ran = Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
