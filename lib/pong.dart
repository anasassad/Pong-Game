import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';

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

  late Animation<double> animation;
  late AnimationController animationController;

  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  checkBoundaries() {
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
    }
    if (posX >= width - 50 && hDir == Direction.right) {
      hDir = Direction.left;
    }

    if (posY >= height - 50 && vDir == Direction.down) {
      vDir == Direction.up;
    }

    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
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
      setState(() {
        (hDir == Direction.right) ? posX += speed : posX -= speed;
        (vDir == Direction.down) ? posY += speed : posY -= speed;
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

  moveBat(DragUpdateDetails details) {
    setState(() {
      batPosition += details.delta.dx;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
