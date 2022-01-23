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

    Paint paintBlue = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
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


    Offset centerOffset = Offset(size.width / 2, size.height / 2);

    const startAngle = -120.0;
    const endAngle = -60.0;

    GaugeObject gaugeObject = GaugeObject(
      center: centerOffset,
      startAngle: startAngle,
      endAngle: endAngle,
      width: width,
      boxSize: size,
      paint: paintBlue,
    );

    canvas.drawPath(gaugeObject.gaugeShapePath!, paintBlue);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class GaugeObject {
  final Offset center;
  final double startAngle;
  final double endAngle;
  final double width;
  final Size boxSize;
  final Paint paint;
  ArcObject? outerArc;
  ArcObject? outerHelperArc;
  ArcObject? centerOuterArc;
  ArcObject? centerArc;
  ArcObject? centerInnerArc;
  ArcObject? innerHelperArc;
  ArcObject? innerArc;
  Path? gaugeShapePath;

  GaugeObject({
    required this.center,
    required this.startAngle,
    required this.endAngle,
    required this.width,
    required this.boxSize,
    required this.paint,
  }) {
    outerArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.5 * width / 100),
      endAngle: endAngle - (3.5 * width / 100),
      radius: min(boxSize.width / 2, boxSize.height / 2),
      paint: paint,
    );
    outerHelperArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.3 * width / 100),
      endAngle: endAngle - (3.3 * width / 100),
      radius: min(boxSize.width / 2, boxSize.height / 2) - (width * 1 / 100),
      paint: paint,
    );
    centerOuterArc = ArcObject(
      center: center,
      startAngle: startAngle + (2.5 * width / 100),
      endAngle: endAngle - (2.5 * width / 100),
      radius: min(boxSize.width / 2, boxSize.height / 2) - (width * 10 / 100),
      paint: paint,
    );
    centerArc = ArcObject(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      radius: min(boxSize.width / 2, boxSize.height / 2) - (width / 2),
      paint: paint,
    );
    ArcObject centerInnerArc = ArcObject(
      center: center,
      startAngle: startAngle + (2.5 * width / 100),
      endAngle: endAngle - (2.5 * width / 100),
      radius: min(boxSize.width / 2, boxSize.height / 2) -
          width +
          (width * 10 / 100),
      paint: paint,
    );
    innerHelperArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.3 * width / 100),
      endAngle: endAngle - (3.3 * width / 100),
      radius: min(boxSize.width / 2, boxSize.height / 2) -
          width +
          (width * 1 / 100),
      paint: paint,
    );
    innerArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.5 * width / 100),
      endAngle: endAngle - (3.5 * width / 100),
      radius: min(boxSize.width / 2, boxSize.height / 2) - width,
      paint: paint,
    );

    gaugeShapePath = Path()
      ..moveTo(
        outerArc!.arcPoints!.startX,
        outerArc!.arcPoints!.startY,
      )
      ..quadraticBezierTo(
          outerHelperArc!.arcPoints!.startX,
          outerHelperArc!.arcPoints!.startY,
          centerOuterArc!.arcPoints!.startX,
          centerOuterArc!.arcPoints!.startY)
      ..quadraticBezierTo(
          centerArc!.arcPoints!.startX,
          centerArc!.arcPoints!.startY,
          centerInnerArc.arcPoints!.startX,
          centerInnerArc.arcPoints!.startY)
      ..quadraticBezierTo(
          innerHelperArc!.arcPoints!.startX,
          innerHelperArc!.arcPoints!.startY,
          innerArc!.arcPoints!.startX,
          innerArc!.arcPoints!.startY)
      ..lineTo(
        innerArc!.arcPoints!.startX,
        innerArc!.arcPoints!.startY,
      )
      ..addArc(
        Rect.fromCircle(center: center, radius: innerArc!.radius),
        radians(innerArc!.startAngle),
        radians(innerArc!.endAngle - innerArc!.startAngle),
      )
      ..lineTo(
        innerArc!.arcPoints!.endX,
        innerArc!.arcPoints!.endY,
      )
      ..quadraticBezierTo(
          innerHelperArc!.arcPoints!.endX,
          innerHelperArc!.arcPoints!.endY,
          centerInnerArc.arcPoints!.endX,
          centerInnerArc.arcPoints!.endY)
      ..quadraticBezierTo(
        centerArc!.arcPoints!.endX,
        centerArc!.arcPoints!.endY,
        centerOuterArc!.arcPoints!.endX,
        centerOuterArc!.arcPoints!.endY,
      )
      ..quadraticBezierTo(
        outerHelperArc!.arcPoints!.endX,
        outerHelperArc!.arcPoints!.endY,
        outerArc!.arcPoints!.endX,
        outerArc!.arcPoints!.endY,
      )
      ..lineTo(
        outerArc!.arcPoints!.endX,
        outerArc!.arcPoints!.endY,
      )
      ..addArc(
        Rect.fromCircle(center: center, radius: outerArc!.radius),
        radians(outerArc!.endAngle),
        radians(-1 * (outerArc!.endAngle-outerArc!.startAngle)),
      )
      ..lineTo(
        outerArc!.arcPoints!.startX,
        outerArc!.arcPoints!.startY,
      )
      ..close();

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
