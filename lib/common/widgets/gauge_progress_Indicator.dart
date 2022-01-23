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
      startAngle: startAngle + (3.5 * width / 100),
      endAngle: endAngle - (3.5 * width / 100),
      radius: min(size.width / 2, size.height / 2),
      paint: paintBlue,
    );
    ArcObject outerHelperArc = ArcObject(
      center: centerOffset,
      startAngle: startAngle + (3.3 * width / 100),
      endAngle: endAngle - (3.3 * width / 100),
      radius: min(size.width / 2, size.height / 2) - (width * 1 / 100),
      paint: paintBlue,
    );
    ArcObject centerOuterArc = ArcObject(
      center: centerOffset,
      startAngle: startAngle + (2.5 * width / 100),
      endAngle: endAngle - (2.5 * width / 100),
      radius: min(size.width / 2, size.height / 2) - (width * 10 / 100),
      paint: paintBlue,
    );
    ArcObject centerArc = ArcObject(
      center: centerOffset,
      startAngle: startAngle,
      endAngle: endAngle,
      radius: min(size.width / 2, size.height / 2) - (width / 2),
      paint: paintBlue,
    );
    ArcObject centerInnerArc = ArcObject(
      center: centerOffset,
      startAngle: startAngle + (2.5 * width / 100),
      endAngle: endAngle - (2.5 * width / 100),
      radius: min(size.width / 2, size.height / 2) - width + (width * 10 / 100),
      paint: paintBlue,
    );
    ArcObject innerHelperArc = ArcObject(
      center: centerOffset,
      startAngle: startAngle + (3.3 * width / 100),
      endAngle: endAngle - (3.3 * width / 100),
      radius: min(size.width / 2, size.height / 2) - width + (width * 1 / 100),
      paint: paintBlue,
    );
    ArcObject innerArc = ArcObject(
      center: centerOffset,
      startAngle: startAngle + (3.5 * width / 100),
      endAngle: endAngle - (3.5 * width / 100),
      radius: min(size.width / 2, size.height / 2) - width,
      paint: paintBlue,
    );

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: outerArc.radius),
        radians(outerArc.startAngle),
        radians(outerArc.endAngle - outerArc.startAngle),
        false,
        paintBlue);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: outerHelperArc.radius),
        radians(outerHelperArc.startAngle),
        radians(outerHelperArc.endAngle - outerHelperArc.startAngle),
        false,
        paintGreen);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: centerOuterArc.radius),
        radians(centerOuterArc.startAngle),
        radians(centerOuterArc.endAngle - centerOuterArc.startAngle),
        false,
        paintRed);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: centerArc.radius),
        radians(centerArc.startAngle),
        radians(centerArc.endAngle - centerArc.startAngle),
        false,
        paintBlack);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: centerInnerArc.radius),
        radians(centerInnerArc.startAngle),
        radians(centerInnerArc.endAngle - centerInnerArc.startAngle),
        false,
        paintRed);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: innerHelperArc.radius),
        radians(innerHelperArc.startAngle),
        radians(innerHelperArc.endAngle - innerHelperArc.startAngle),
        false,
        paintGreen);

    canvas.drawArc(
        Rect.fromCircle(center: centerOffset, radius: innerArc.radius),
        radians(innerArc.startAngle),
        radians(innerArc.endAngle - innerArc.startAngle),
        false,
        paintBlue);

    Path path1 = Path();
    path1.moveTo(outerArc.arcPoints!.startX, outerArc.arcPoints!.startY);
    path1.quadraticBezierTo(
        outerHelperArc.arcPoints!.startX, outerHelperArc.arcPoints!.startY,
        centerOuterArc.arcPoints!.startX, centerOuterArc.arcPoints!.startY);
    path1.quadraticBezierTo(
        centerArc.arcPoints!.startX, centerArc.arcPoints!.startY,
        centerInnerArc.arcPoints!.startX, centerInnerArc.arcPoints!.startY);
    path1.quadraticBezierTo(
        innerHelperArc.arcPoints!.startX, innerHelperArc.arcPoints!.startY,
        innerArc.arcPoints!.startX, innerArc.arcPoints!.startY);
    canvas.drawPath(path1, paintRed);

    Path path2 = Path();
    path2.moveTo(outerArc.arcPoints!.endX, outerArc.arcPoints!.endY);
    path2.quadraticBezierTo(
        outerHelperArc.arcPoints!.endX, outerHelperArc.arcPoints!.endY,
        centerOuterArc.arcPoints!.endX, centerOuterArc.arcPoints!.endY);
    path2.quadraticBezierTo(
        centerArc.arcPoints!.endX, centerArc.arcPoints!.endY,
        centerInnerArc.arcPoints!.endX, centerInnerArc.arcPoints!.endY);
    path2.quadraticBezierTo(
        innerHelperArc.arcPoints!.endX, innerHelperArc.arcPoints!.endY,
        innerArc.arcPoints!.endX, innerArc.arcPoints!.endY);
    canvas.drawPath(path2, paintBlue);

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
