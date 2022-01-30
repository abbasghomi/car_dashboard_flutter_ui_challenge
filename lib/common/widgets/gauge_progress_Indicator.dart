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

  final List<double>? gapsValues;
  final int partsCount;

  GaugeProgressIndicator({
    required this.bgColor,
    required this.lineColor,
    required this.currentValue,
    required this.startValue,
    required this.endValue,
    required this.width,
    required this.partsCount,
    required this.gapArrangement,
    this.gapsValues,
    this.fillDirection = FillDirection.clockWise,
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
      ..style = PaintingStyle.fill
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
      gapArrangement: gapArrangement,
      partsCount: gapArrangement == GapArrangement.noGap
          ? 1
          : gapArrangement == GapArrangement.valueList
              ? gapsValues!.length + 1
              : partsCount,
      gapsValues: gapArrangement == GapArrangement.noGap ? null : gapsValues,
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

    for (var i = 0; i < gaugeObject.gaugePartObjects.length; i++) {
      // final paint = Paint();
      // paint.color = ColorTween(
      //   begin: Colors.green,
      //   end: Colors.red,
      // ).transform(radians(item.startAngle) / radians( endAngle))!;
      // paint.color = ColorTween(
      //   begin: Colors.black,
      //   end: Colors.white,
      // ).transform(item.startValue/(endValue-startValue))!;
      // paint.shader =  SweepGradient(
      //   startAngle: radians(0.0),
      //   endAngle: radians(90.0),
      //   tileMode: TileMode.repeated,
      //   colors:const [Colors.black,Colors.white]
      // ).createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height));

      // paint.shader = SweepGradient(
      //   colors: const [
      //     Colors.blue,
      //     Colors.yellow,
      //     //Colors.blue,
      //   ],
      //   stops: [
      //     //gaugeObject.valueToColorStopValue(0),
      //     gaugeObject.valueToColorStopValue(-gaugeObject.gapsValues![0]),
      //     gaugeObject.valueToColorStopValue(endValue),
      //     //gaugeObject.valueToColorStopValue(gaugeObject.gapsValues![2]),
      //   ],
      //   startAngle: radians( startAngle),
      //   //endAngle: radians(endAngle.abs()),
      // ).createShader(Rect.fromCircle(
      //   center: centerOffset,
      //   radius: min(size.width / 2, size.height / 2),
      // ));

      // paint .shader = SweepGradient(
      //     colors: const [
      //       Colors.black,
      //       Colors.white,
      //     ],
      //   startAngle: radians(startAngle),
      //   endAngle: radians(endAngle),
      //   ).createShader(Rect.fromCircle(
      //     center: centerOffset,
      //     radius:  min(size.width / 2, size.height / 2),
      //   ));
      // paint .shader = const RadialGradient(
      //     colors: [
      //       Colors.black,
      //       Colors.white,
      //     ],
      //   ).createShader(Rect.fromCircle(
      //     center: centerOffset,
      //     radius:  min(size.width / 2, size.height / 2),
      //   ));

      // Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

      // a fancy rainbow gradient
      // final Gradient gradient = RadialGradient(
      //   colors: <Color>[
      //     Colors.green.withOpacity(1.0),
      //     Colors.green.withOpacity(0.3),
      //     Colors.yellow.withOpacity(0.2),
      //     Colors.red.withOpacity(0.1),
      //     Colors.red.withOpacity(0.0),
      //   ],
      //   stops: const [
      //     0.0,
      //     0.5,
      //     0.7,
      //     0.9,
      //     1.0,
      //   ],
      // );

      // create the Shader from the gradient and the bounding square
      //final Paint paint = Paint()..shader = gradient.createShader(rect);

      canvas.drawPath(
          gaugeObject.gaugePartObjects[i].gaugeShapePath!, paintBlue);
      if (gaugeObject.gaugeCurrentValuePartObjects.length > i) {
        canvas.drawPath(
            gaugeObject.gaugeCurrentValuePartObjects[i].gaugeShapePath!,
            paintRed);
      }
    }

    // const gradient = SweepGradient(
    //   startAngle: 3 * pi / 2,
    //   endAngle: 7 * pi / 2,
    //   tileMode: TileMode.repeated,
    //   colors: [Colors.red, Colors.green],
    // );
    //
    // final paint = Paint()
    //   ..shader = gradient.createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
    //   ..strokeCap = StrokeCap.butt  // StrokeCap.round is not recommended.
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = width;
    // final center = Offset(size.width / 2, size.height / 2);
    // final radius = min(size.width / 2, size.height / 2) - (width / 2);
    // const startAngleX = -pi / 2;
    // final sweepAngleX = 2 * pi * currentValue;
    // canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
    //     startAngleX, sweepAngleX, false, paint);
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
  var gaugeCurrentValuePartObjects = <GaugePartObject>[];

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
  }) : assert((partsCount > 1 && gapArrangement != GapArrangement.noGap) ||
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
    return (value * totalDegree.abs()) / (endValue - startValue);
  }

  double valueToDegreeDefault(double value) {
    return (value * endAngle) / (endValue - startValue);
  }

  double valueToColorStopValue(double value) {
    return value / (endValue - startValue);
  }

  double degreeToValue(double degree) {
    return (endValue - startValue) * degree / (endAngle - startAngle);
  }

  void generateGaugeParts() {
    if (gapArrangement == GapArrangement.noGap) {
      noGapPathGenerator();
      noGapCurrentValuePathGenerator();
    } else if (gapArrangement == GapArrangement.evenly) {
      evenGapPathGenerator();
      evenGapCurrentValuePathGenerator();
    } else if (gapArrangement == GapArrangement.valueList) {
      valuesListPathGenerator();
      valuesListCurrentValuePathGenerator();
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

  void noGapCurrentValuePathGenerator() {
    gaugeCurrentValuePartObjects = [];
    gaugeCurrentValuePartObjects.add(GaugePartObject(
      startValue: startValue,
      endValue: startValue + currentValue,
      //endValue,
      fillDirection: fillDirection,
      center: center,
      startAngle: startAngle,
      endAngle: startAngle + valueToDegree(currentValue, endAngle - startAngle),
      width: width,
      radius: outerRadius,
      paint: paint,
      startCapShape: CapShape.curve,
      endCapShape: CapShape.curve,
    ));
  }

  void evenGapCurrentValuePathGenerator() {
    gaugeCurrentValuePartObjects = <GaugePartObject>[];
    generateEvenArcAngles();
    var eachPartValue = (endValue - startValue) / partsCount;

    for (var i = 0; i < arcAngles.length; i++) {
      var startValueTemp = i * eachPartValue;
      var endValueTemp = i == arcAngles.length - 1
          ? endValue
          : (i * eachPartValue) + eachPartValue;

      var startAngleTemp = arcAngles[i].start;
      var endAngleTemp = arcAngles[i].end;

      if (currentValue >= startValueTemp && currentValue <= endValueTemp) {
        var endAngleX =  startAngle + valueToDegree(currentValue, endAngle - startAngle);

        startValueTemp = i * eachPartValue;
        endValueTemp = currentValue;

        startAngleTemp = arcAngles[i].start;
        endAngleTemp = endAngleX;
      }
      gaugeCurrentValuePartObjects.add(GaugePartObject(
        startValue: startValueTemp,
        endValue: endValueTemp,
        fillDirection: fillDirection,
        center: center,
        startAngle: startAngleTemp,
        endAngle: endAngleTemp,
        width: width,
        radius: outerRadius,
        paint: paint,
        startCapShape: i == 0 ? startCapShape : CapShape.flat,
        endCapShape: i < arcAngles.length - 1 ? CapShape.flat : endCapShape,
      ));
      if (currentValue >= startValueTemp && currentValue <= endValueTemp) {
        break;
      }
    }
  }

  void valuesListCurrentValuePathGenerator() {
    gaugeCurrentValuePartObjects = <GaugePartObject>[];
    var parts = generateNotEvenArcAngles();

    for (var i = 0; i < arcAngles.length; i++) {
      var sum = 0.0;
      for (var j = 0; j < i; j++) {
        sum += parts[j];
      }


      var startValueTemp = sum;
      var endValueTemp =  i == arcAngles.length - 1 ? endValue : sum + parts[i];

      var startAngleTemp = arcAngles[i].start;
      var endAngleTemp = arcAngles[i].end;

      if (currentValue >= startValueTemp && currentValue <= endValueTemp) {
        var endAngleX =  startAngle + valueToDegree(currentValue, endAngle - startAngle);

        startValueTemp = sum;
        endValueTemp = currentValue;

        startAngleTemp = arcAngles[i].start;
        endAngleTemp = endAngleX;
      }


      gaugeCurrentValuePartObjects.add(GaugePartObject(
        startValue: startValueTemp,
        endValue: endValueTemp,
        fillDirection: fillDirection,
        center: center,
        startAngle: startAngleTemp,
        endAngle: endAngleTemp,
        width: width,
        radius: outerRadius,
        paint: paint,
        startCapShape: i == 0 ? startCapShape : CapShape.flat,
        endCapShape: i < arcAngles.length - 1 ? CapShape.flat : endCapShape,
      ));

      if (currentValue >= startValueTemp && currentValue <= endValueTemp) {
        break;
      }
    }

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
