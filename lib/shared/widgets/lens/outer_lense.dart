import 'dart:math';
import 'package:flutter/material.dart';

class OuterLense extends StatelessWidget {
  const OuterLense({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 100), // Adjust size as needed
      painter: _GradientRoundedRectanglePainter(),
    );
  }
}

class _GradientRoundedRectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.green, Colors.yellow],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..arcTo(Rect.fromLTWH(size.width - 20, 0, 20, 20), 0, pi / 2, false)
      ..lineTo(size.width, size.height - 20)
      ..arcTo(Rect.fromLTWH(size.width - 20, size.height - 20, 20, 20), -pi / 2,
          0, false)
      ..lineTo(0, size.height)
      ..arcTo(Rect.fromLTWH(0, size.height - 20, 20, 20), pi, pi / 2, false)
      ..lineTo(0, 20)
      ..arcTo(Rect.fromLTWH(0, 0, 20, 20), pi / 2, 0, false); // Notch

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_GradientRoundedRectanglePainter oldDelegate) => false;
}
