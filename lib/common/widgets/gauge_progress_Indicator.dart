import 'package:flutter/material.dart';
import 'dart:math' show cos, max, min, pi, sin;
import 'package:vector_math/vector_math.dart' show radians;

enum FillDirection { clockWise, counterClockWise }
enum GapArrangement { evenly, angleList }

class GaugeProgressIndicator extends CustomPainter {
  final FillDirection fillDirection;
  final GapArrangement gapArrangement;
  final double startAngle;
  final double endAngle;

  final Color bgColor;
  final Color lineColor;
  final double width;
  final double percent;

  GaugeProgressIndicator({
    required this.bgColor,
    required this.lineColor,
    required this.percent,
    required this.width,
    this.fillDirection = FillDirection.clockWise,
    this.gapArrangement = GapArrangement.evenly,
    this.startAngle = 0.0,
    this.endAngle = 359.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgLine = Paint()
      ..color = bgColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt;

    Paint completedLine = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt;

    // final paint = ColorTween(
    //   begin: Colors.green,
    //   end: Colors.red,
    // );

    // Offset offset = Offset(size.width / 2, size.height / 2);
    // double radius = min(size.width / 2, size.height / 2);
    // canvas.drawArc(Rect.fromCircle(center: offset, radius: radius), 2.5,
    //     2 * pi * 0.7, false, bgLine);
    // double sweepAngle = 2 * pi * percent;
    // canvas.drawArc(Rect.fromCircle(center: offset, radius: radius), 2.5,
    //     sweepAngle, false, completedLine);

    Paint paintBlue = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    Paint paintGreen = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    Paint paintRed = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    Paint paintBlack = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Path path1 = Path();
    // path1.lineTo(0, (size.height *3/ 4));
    // path1.quadraticBezierTo(0, (size.height *3/ 4), 1, (size.height *3/ 4)+1);
    // path1.quadraticBezierTo(size.width / 2, size.height, size.width-1, (size.height*3/ 4)+1);
    // path1.quadraticBezierTo(size.width-1 , (size.height *3/ 4)+1, size.width, size.height*3/ 4);
    // path1. lineTo(size.width, 0);
    // canvas.drawPath(path1, paint);

    Offset centerOffset = Offset(size.width / 2, size.height / 2);

    const startAngle = -120.0;
    const endAngle = -60.0;

    ArcObject outerArc = ArcObject(
      center: centerOffset,
      startAngle: startAngle + 3.5,
      endAngle: endAngle - 3.5,
      radius: min(size.width / 2, size.height / 2),
      paint: paintBlue,
    );

    double outerRadius = min(size.width / 2, size.height / 2);
    double outerHelperRadius =
        min(size.width / 2, size.height / 2) - (width * 1 / 100); //0.1;
    double centerOuterRadius =
        min(size.width / 2, size.height / 2) - (width * 10 / 100); //- 1;
    double centerRadius = min(size.width / 2, size.height / 2) - (width / 2);
    double centerInnerRadius = min(size.width / 2, size.height / 2) -
        width +
        (width * 10 / 100); //- 1;
    double innerHelperRadius =
        min(size.width / 2, size.height / 2) - width + (width * 1 / 100); //0.1;
    double innerRadius = min(size.width / 2, size.height / 2) - width;

    double outerStartAngle = startAngle + 3.5;
    double outerEndAngle = endAngle - 3.5;

    double outerHelperStartAngle = startAngle + 3.3;
    double outerHelperEndAngle = endAngle - 3.3;

    double centerOuterStartAngle = startAngle + 3;
    double centerOuterEndAngle = endAngle - 3;

    double centerStartAngle = startAngle;
    double centerEndAngle = endAngle;

    double centerInnerStartAngle = startAngle + 3;
    double centerInnerEndAngle = endAngle - 3;

    double innerHelperStartAngle = startAngle + 3.3;
    double innerHelperEndAngle = endAngle - 3.3;

    double innerStartAngle = startAngle + 3.5;
    double innerEndAngle = endAngle - 3.5;

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: outerRadius),
        radians(outerStartAngle),
        radians(outerEndAngle - outerStartAngle),
        false,
        paintBlue);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: outerHelperRadius),
        radians(outerHelperStartAngle),
        radians(outerHelperEndAngle - outerHelperStartAngle),
        false,
        paintGreen);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: centerOuterRadius),
        radians(centerOuterStartAngle),
        radians(centerOuterEndAngle - centerOuterStartAngle),
        false,
        paintRed);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: centerRadius),
        radians(centerStartAngle),
        radians(centerEndAngle - centerStartAngle),
        false,
        paintBlack);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: centerInnerRadius),
        radians(centerInnerStartAngle),
        radians(centerInnerEndAngle - centerInnerStartAngle),
        false,
        paintRed);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: innerHelperRadius),
        radians(innerHelperStartAngle),
        radians(innerHelperEndAngle - innerHelperStartAngle),
        false,
        paintGreen);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: innerRadius),
        radians(innerStartAngle),
        radians(innerEndAngle - innerStartAngle),
        false,
        paintBlue);

    // Path path = Path()..addArc(oval, startAngle, sweepAngle);

    //
    // secondPaint
    //   ..color = Colors.black
    //   ..shader = SweepGradient(
    //     colors: const [
    //       Colors.red,
    //       Colors.green,
    //     ],
    //     startAngle: radians(0),
    //     endAngle: radians(360),
    //     transform:
    //     GradientRotation(radians(0 - (360 / 1.5))),
    //   ).createShader(secondRect);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ArcObject {
  final Offset center;
  final double startAngle;
  final double endAngle;
  final double radius;
  ArcPoints? arcPoints;
  final Paint paint;

  ArcObject({
    required this.center,
    required this.startAngle,
    required this.endAngle,
    required this.radius,
    required this.paint,
  }) {
    arcPoints = getArcStartAndEndPoints(
      center.dx,
      center.dy,
      radius,
      startAngle,
      endAngle,
    );
  }

  ArcPoints getArcStartAndEndPoints(double centerX, double centerY,
      double radius, double startAngle, double endAngle) {
    return ArcPoints(
      startX: centerX + radius * cos(radians(startAngle)),
      startY: centerY + radius * sin(radians(startAngle)),
      endX: centerX + radius * cos(radians(endAngle)),
      endY: centerY + radius * sin(radians(endAngle)),
    );
  }
}

class ArcPoints {
  final double startX;
  final double startY;
  final double endX;
  final double endY;

  ArcPoints({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });
}
