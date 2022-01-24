import 'package:flutter/material.dart';
import 'dart:math' show cos, min, sin, pi;
import 'package:vector_math/vector_math.dart' show radians;

enum FillDirection { clockWise, counterClockWise }
enum GapArrangement { noGap, evenly, valueList }
enum CapShape { curve, flat }

class GaugeProgressIndicator extends CustomPainter {
  final FillDirection fillDirection;
  final GapArrangement gapArrangement;
  final double startAngle;
  final double endAngle;

  final Color bgColor;
  final Color lineColor;
  final double width;
  final double currentValue;
  final double startValue;
  final double endValue;

  GaugeProgressIndicator({
    required this.bgColor,
    required this.lineColor,
    required this.currentValue,
    required this.startValue,
    required this.endValue,
    required this.width,
    this.fillDirection = FillDirection.clockWise,
    this.gapArrangement = GapArrangement.evenly,
    this.startAngle = 0.0,
    this.endAngle = 359.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
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

    var gaugeObject = GaugeObject(
      startValue: startValue,
      endValue: endValue,
      currentValue: currentValue,
      fillDirection: FillDirection.clockWise,
      gapArrangement: GapArrangement.valueList,
      partsCount: 4,
      gapsValues: [64.0, 78.0, 90.0],
      gapSizeDegree: 0.1,
      center: centerOffset,
      startAngle: startAngle,
      endAngle: endAngle,
      width: width,
      boxSize: size,
      startCapShape: CapShape.curve,
      endCapShape: CapShape.curve,
      paint: paintBlue,
    );

    for (var item in gaugeObject.gaugePartObjects) {

      final paint = Paint();
      paint.color = ColorTween(
        begin: Colors.green,
        end: Colors.red,
      ).transform(radians(item.startAngle) / radians( endAngle))!;


      canvas.drawPath(item.gaugeShapePath!, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class GaugeObject {
  final Offset center;
  final double startValue;
  final double endValue;
  final double currentValue;
  final double startAngle;
  final double endAngle;
  final double width;
  final Size boxSize;
  final Paint paint;
  final int partsCount;
  final double gapSizeDegree;
  final List<double>? gapsValues;
  final FillDirection fillDirection;
  final GapArrangement gapArrangement;
  final CapShape startCapShape;
  final CapShape endCapShape;

  var gaugePartObjects = <GaugePartObject>[];
  var arcAngles = <ArcAngle>[];
  var outerRadius = 0.0;
  var gapDegreeEqualValue = 0.0;

  GaugeObject({
    required this.center,
    required this.startValue,
    required this.endValue,
    required this.currentValue,
    required this.startAngle,
    required this.endAngle,
    required this.width,
    required this.boxSize,
    required this.paint,
    required this.fillDirection,
    required this.gapArrangement,
    required this.startCapShape,
    required this.endCapShape,
    this.partsCount = 1,
    this.gapSizeDegree = 1.0,
    this.gapsValues,
  }) : assert((partsCount > 1 &&
                gapArrangement != GapArrangement.noGap &&
                gapsValues == null) ||
            (partsCount == 1 &&
                gapArrangement == GapArrangement.noGap &&
                gapsValues == null &&
                gapSizeDegree > 0) ||
            (gapsValues != null &&
                gapsValues.length == partsCount - 1 &&
                partsCount > 1 &&
                gapArrangement == GapArrangement.valueList &&
                gapSizeDegree > 0)) {
    outerRadius = min(boxSize.width / 2, boxSize.height / 2);
    gapDegreeEqualValue = degreeToValue(gapSizeDegree);
    generateGaugeParts();
  }

  double valueToDegree(double value, totalDegree) {
    return (value * totalDegree) / (endValue - startValue);
  }

  double degreeToValue(double degree) {
    return (endValue - startValue) * degree / (endAngle - startAngle);
  }

  void generateGaugeParts() {
    if (gapArrangement == GapArrangement.noGap) {
      noGapPathGenerator();
    } else if (gapArrangement == GapArrangement.evenly) {
      evenGapPathGenerator();
    } else if (gapArrangement == GapArrangement.valueList) {
      valuesListPathGenerator();
    }
  }

  void noGapPathGenerator() {
    gaugePartObjects = [];
    gaugePartObjects.add(GaugePartObject(
      startValue: startValue,
      endValue: endValue,
      fillDirection: fillDirection,
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      width: width,
      radius: outerRadius,
      paint: paint,
      startCapShape: CapShape.curve,
      endCapShape: CapShape.curve,
    ));
  }

  void evenGapPathGenerator() {
    gaugePartObjects = <GaugePartObject>[];
    generateEvenArcAngles();
    var eachPartValue = (endValue - startValue) / partsCount;

    for (var i = 0; i < arcAngles.length; i++) {
      gaugePartObjects.add(GaugePartObject(
        startValue: i * eachPartValue,
        endValue: i == arcAngles.length - 1
            ? endValue
            : (i * eachPartValue) + eachPartValue,
        fillDirection: fillDirection,
        center: center,
        startAngle: arcAngles[i].start,
        endAngle: arcAngles[i].end,
        width: width,
        radius: outerRadius,
        paint: paint,
        startCapShape: i == 0 ? startCapShape : CapShape.flat,
        endCapShape: i < arcAngles.length - 1 ? CapShape.flat : endCapShape,
      ));
    }
  }

  void valuesListPathGenerator() {
    gaugePartObjects = <GaugePartObject>[];
    var parts = generateNotEvenArcAngles();

    for (var i = 0; i < arcAngles.length; i++) {
      var sum = 0.0;
      for (var j = 0; j < i; j++) {
        sum += parts[j];
      }
      gaugePartObjects.add(GaugePartObject(
        startValue: sum,
        endValue: i == arcAngles.length - 1 ? endValue : sum + parts[i],
        fillDirection: fillDirection,
        center: center,
        startAngle: arcAngles[i].start,
        endAngle: arcAngles[i].end,
        width: width,
        radius: outerRadius,
        paint: paint,
        startCapShape: i == 0 ? startCapShape : CapShape.flat,
        endCapShape: i < arcAngles.length - 1 ? CapShape.flat : endCapShape,
      ));
    }
  }

  void generateEvenArcAngles() {
    arcAngles = [];
    var sumOfGapsDegree = (partsCount - 1) * gapSizeDegree;
    var totalAngle = endAngle - startAngle;
    var totalUsableDegree = totalAngle - sumOfGapsDegree;
    var eachArcDegree = totalUsableDegree / partsCount;
    var angle = 0.0;
    while (angle < totalAngle) {
      var startAngleTemp = startAngle + angle;
      angle += eachArcDegree;
      var endAngleTemp = startAngle + angle;
      arcAngles.add(ArcAngle(start: startAngleTemp, end: endAngleTemp));
      angle += gapSizeDegree;
    }
  }

  List<double> generateNotEvenArcAngles() {
    arcAngles = [];
    var sumOfGapsDegree = (gapsValues!.length) * gapSizeDegree;
    var totalAngle = endAngle - startAngle;
    var totalUsableDegree = totalAngle - sumOfGapsDegree;

    var parts = <double>[];
    var value = 0.0;
    var index = 0;
    while (value < endValue) {
      if (index >= gapsValues!.length) {
        var sum = 0.0;
        for (var item in parts) {
          sum += item + gapDegreeEqualValue;
        }
        parts.add(endValue - sum);
        value += endValue - sum;
      } else {
        parts.add(gapsValues![index] - value - (gapDegreeEqualValue / 2));
        value += parts.last + gapDegreeEqualValue;
        index++;
      }
    }

    var angle = 0.0;
    index = 0;
    while (angle < totalAngle) {
      var partValueEqualDegree = valueToDegree(parts[index], totalAngle);
      var startAngleTemp = startAngle + angle;

      angle += partValueEqualDegree - (gapSizeDegree / 2);
      var endAngleTemp = startAngle + angle;
      arcAngles.add(ArcAngle(start: startAngleTemp, end: endAngleTemp));
      if (index == parts.length - 1) {
        angle += totalAngle - angle;
      } else {
        angle += (gapSizeDegree / 2);
      }
      index++;
    }

    return parts;
  }
}

class GaugePartObject {
  final Offset center;
  final double startAngle;
  final double endAngle;
  final double width;
  final double radius;
  final Paint paint;
  final FillDirection fillDirection;
  final CapShape startCapShape;
  final CapShape endCapShape;
  final double startValue;
  final double endValue;

  ArcObject? outerArc;
  ArcObject? outerHelperArc;
  ArcObject? centerOuterArc;
  ArcObject? centerArc;
  ArcObject? centerInnerArc;
  ArcObject? innerHelperArc;
  ArcObject? innerArc;
  Path? gaugeShapePath;

  GaugePartObject({
    required this.startValue,
    required this.endValue,
    required this.center,
    required this.startAngle,
    required this.endAngle,
    required this.width,
    required this.radius,
    required this.paint,
    required this.fillDirection,
    required this.startCapShape,
    required this.endCapShape,
  }) {
    outerArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.5 * width / 100),
      endAngle: endAngle - (3.5 * width / 100),
      radius: radius,
      paint: paint,
    );
    outerHelperArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.3 * width / 100),
      endAngle: endAngle - (3.3 * width / 100),
      radius: radius - (width * 1 / 100),
      paint: paint,
    );
    centerOuterArc = ArcObject(
      center: center,
      startAngle: startAngle + (2.5 * width / 100),
      endAngle: endAngle - (2.5 * width / 100),
      radius: radius - (width * 10 / 100),
      paint: paint,
    );
    centerArc = ArcObject(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      radius: radius - (width / 2),
      paint: paint,
    );
    centerInnerArc = ArcObject(
      center: center,
      startAngle: startAngle + (2.5 * width / 100),
      endAngle: endAngle - (2.5 * width / 100),
      radius: radius - width + (width * 10 / 100),
      paint: paint,
    );
    innerHelperArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.3 * width / 100),
      endAngle: endAngle - (3.3 * width / 100),
      radius: radius - width + (width * 1 / 100),
      paint: paint,
    );
    innerArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.5 * width / 100),
      endAngle: endAngle - (3.5 * width / 100),
      radius: radius - width,
      paint: paint,
    );

    gaugeShapePath = Path()
      ..moveTo(
        outerArc!.arcPoints!.startX,
        outerArc!.arcPoints!.startY,
      );
    if (startCapShape == CapShape.curve) {
      gaugeShapePath?.quadraticBezierTo(
          outerHelperArc!.arcPoints!.startX,
          outerHelperArc!.arcPoints!.startY,
          centerOuterArc!.arcPoints!.startX,
          centerOuterArc!.arcPoints!.startY);
      gaugeShapePath?.quadraticBezierTo(
          centerArc!.arcPoints!.startX,
          centerArc!.arcPoints!.startY,
          centerInnerArc!.arcPoints!.startX,
          centerInnerArc!.arcPoints!.startY);
      gaugeShapePath?.quadraticBezierTo(
          innerHelperArc!.arcPoints!.startX,
          innerHelperArc!.arcPoints!.startY,
          innerArc!.arcPoints!.startX,
          innerArc!.arcPoints!.startY);
    } else {
      gaugeShapePath?.lineTo(
          innerArc!.arcPoints!.startX, innerArc!.arcPoints!.startY);
    }

    gaugeShapePath?.arcTo(
      Rect.fromCircle(center: center, radius: innerArc!.radius),
      radians(innerArc!.startAngle),
      radians(innerArc!.endAngle - innerArc!.startAngle),
      false,
    );

    if (endCapShape == CapShape.curve) {
      gaugeShapePath?.quadraticBezierTo(
          innerHelperArc!.arcPoints!.endX,
          innerHelperArc!.arcPoints!.endY,
          centerInnerArc!.arcPoints!.endX,
          centerInnerArc!.arcPoints!.endY);
      gaugeShapePath?.quadraticBezierTo(
        centerArc!.arcPoints!.endX,
        centerArc!.arcPoints!.endY,
        centerOuterArc!.arcPoints!.endX,
        centerOuterArc!.arcPoints!.endY,
      );
      gaugeShapePath?.quadraticBezierTo(
        outerHelperArc!.arcPoints!.endX,
        outerHelperArc!.arcPoints!.endY,
        outerArc!.arcPoints!.endX,
        outerArc!.arcPoints!.endY,
      );
    } else {
      gaugeShapePath?.lineTo(
          outerArc!.arcPoints!.endX, outerArc!.arcPoints!.endY);
    }
    gaugeShapePath?.arcTo(
      Rect.fromCircle(center: center, radius: outerArc!.radius),
      radians(outerArc!.endAngle),
      radians(-1 * (outerArc!.endAngle - outerArc!.startAngle)),
      false,
    );
    gaugeShapePath?.close();
  }
}

class ArcObject {
  final Offset center;
  final double startAngle;
  final double endAngle;
  final double radius;
  ArcPoint? arcPoints;
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

  ArcPoint getArcStartAndEndPoints(double centerX, double centerY,
      double radius, double startAngle, double endAngle) {
    return ArcPoint(
      startX: centerX + radius * cos(radians(startAngle)),
      startY: centerY + radius * sin(radians(startAngle)),
      endX: centerX + radius * cos(radians(endAngle)),
      endY: centerY + radius * sin(radians(endAngle)),
    );
  }
}

class ArcPoint {
  final double startX;
  final double startY;
  final double endX;
  final double endY;

  ArcPoint({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });
}

class ArcAngle {
  final double start;
  final double end;

  ArcAngle({required this.start, required this.end});
}
