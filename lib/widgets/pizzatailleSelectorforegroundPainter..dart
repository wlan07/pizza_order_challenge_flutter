import 'package:flutter/material.dart';

class PTailleSelectorForeGroundPainter extends CustomPainter {
  const PTailleSelectorForeGroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        Path()
          ..moveTo(size.width / 3, 5)
          ..quadraticBezierTo(size.width / 2, -5, 2 * size.width / 3, 5),
        Paint()
          ..color = Color(0xff9E1208)
          ..strokeWidth = 8.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(PTailleSelectorForeGroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(PTailleSelectorForeGroundPainter oldDelegate) =>
      false;
}
