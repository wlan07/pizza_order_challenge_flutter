import 'package:flutter/material.dart';

class PIngredientSelectorForeGroundPainter extends CustomPainter {
  const PIngredientSelectorForeGroundPainter();

  @override
  void paint(Canvas canvas, Size size) {

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2 + 40),
        3.0,
        Paint()
          ..color = Color(0xff9E1208)
          ..strokeWidth = 8.0
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(PIngredientSelectorForeGroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(
          PIngredientSelectorForeGroundPainter oldDelegate) =>
      false;
}
