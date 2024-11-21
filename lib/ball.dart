import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  const Ball({super.key});

  @override
  Widget build(BuildContext context) {
    const double dimension = 50;
    return Container(
      width: dimension,
      height: dimension,
      decoration:
          const BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
    );
  }
}
