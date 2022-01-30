import 'dart:ui' as ui;
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
  final Color textColor;
  final double width;
  final double currentSpeed;
  final double currentGear;
  final double startValue;
  final double endValue;

  final List<double>? gapsValues;
  final List<Color>? fillColorValues;
  final int partsCount;

  final ui.Image? image;

  GaugeProgressIndicator({
    required this.bgColor,
    required this.lineColor,
    required this.textColor,
    required this.currentSpeed,
    required this.currentGear,
    required this.startValue,
    required this.endValue,
    required this.width,
    required this.partsCount,
    required this.gapArrangement,
    this.gapsValues,
    this.fillColorValues,
    this.fillDirection = FillDirection.clockWise,
    this.startAngle = 0.0,
    this.endAngle = 359.0,
    this.image,
  }) : assert((gapArrangement == GapArrangement.valueList &&
                gapsValues != null &&
                gapsValues.isNotEmpty &&
                fillColorValues != null &&
                fillColorValues.length == gapsValues.length + 1) ||
            (gapArrangement == GapArrangement.noGap && partsCount == 1) ||
            (gapArrangement == GapArrangement.evenly && partsCount > 1));

  @override
  void paint(Canvas canvas, Size size) {
    Paint indicatorBackPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
    Paint indicatorForegroundPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    Offset centerOffset = Offset(size.width / 2, size.height / 2);

    var gaugeObject = GaugeObject(
      startValue: startValue,
      endValue: endValue,
      currentValue: currentSpeed,
      fillDirection: FillDirection.clockWise,
      gapArrangement: gapArrangement,
      partsCount: gapArrangement == GapArrangement.noGap
          ? 1
          : gapArrangement == GapArrangement.valueList
              ? gapsValues!.length + 1
              : partsCount,
      gapsValues: gapArrangement == GapArrangement.noGap ? null : gapsValues,
      gapSizeDegree: 2.0,
      center: centerOffset,
      startAngle: startAngle,
      endAngle: endAngle,
      width: width,
      boxSize: size,
      startCapShape: CapShape.curve,
      endCapShape: CapShape.curve,
    );

    for (var i = 0; i < gaugeObject.gaugePartObjects.length; i++) {
      canvas.drawPath(
          gaugeObject.gaugePartObjects[i].gaugeShapePath!, indicatorBackPaint);
    }

    if (gapArrangement == GapArrangement.noGap) {
      for (var i = 0; i < gaugeObject.gaugePartObjects.length; i++) {
        if (gaugeObject.gaugeCurrentValuePartObjects.length > i) {
          canvas.drawPath(
              gaugeObject.gaugeCurrentValuePartObjects[i].gaugeShapePath!,
              indicatorForegroundPaint);
        }
      }
    } else if (gapArrangement == GapArrangement.evenly) {
      for (var i = 0; i < gaugeObject.gaugePartObjects.length; i++) {
        if (gaugeObject.gaugeCurrentValuePartObjects.length > i) {
          canvas.drawPath(
              gaugeObject.gaugeCurrentValuePartObjects[i].gaugeShapePath!,
              indicatorForegroundPaint);
        }
      }
    }
    if (gapArrangement == GapArrangement.valueList) {
      var glowPaint = Paint()
        ..color = textColor.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      var paintList = <Paint>[];
      for (var item in fillColorValues!) {
        var tmpPaint = Paint()
          ..color = item
          ..style = PaintingStyle.fill;
        paintList.add(tmpPaint);
      }
      for (var i = 0; i < gaugeObject.gaugePartObjects.length; i++) {
        if (gaugeObject.gaugeCurrentValuePartObjects.length - 1 == i) {
          var startX = gaugeObject
              .gaugeCurrentValuePartObjects[i].outerArc!.arcPoints!.endX;
          var startY = gaugeObject
              .gaugeCurrentValuePartObjects[i].outerArc!.arcPoints!.endY;
          var endX = gaugeObject
              .gaugeCurrentValuePartObjects[i].innerArc!.arcPoints!.endX;
          var endY = gaugeObject
              .gaugeCurrentValuePartObjects[i].innerArc!.arcPoints!.endY;
          var startGlowOffset = Offset(startX, startY);
          var endGlowOffset = Offset(endX, endY);

          canvas.drawLine(startGlowOffset, endGlowOffset, glowPaint);
        }
        if (gaugeObject.gaugeCurrentValuePartObjects.length > i) {
          canvas.drawPath(
              gaugeObject.gaugeCurrentValuePartObjects[i].gaugeShapePath!,
              paintList[i]);
        }
      }
    }

    drawCenterContents(canvas, size, centerOffset);

    drawGears(canvas, size, centerOffset);

    // final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    // final gradient = SweepGradient(
    //   startAngle: -2 * pi / 2,
    //   endAngle: radians(128.0),
    //   tileMode: TileMode.repeated,
    //   colors: [Colors.white.withOpacity(0.0), Colors.white.withOpacity(1.0)],
    // );
    //
    // final paintxx = Paint()
    //   ..shader = gradient.createShader(rect)
    //   ..strokeCap = StrokeCap.butt // StrokeCap.round is not recommended.
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 50;
    // final center = Offset(size.width / 2, size.height / 2);
    // final radius = min(size.width / 2, size.height / 2) - (width / 2) - 33.0;
    // const startAnglex = -2 * pi / 2;
    // var sweepAnglex = radians(128.0);
    // canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAnglex,
    //     sweepAnglex, false, paintxx);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  drawCenterContents(Canvas canvas, Size size, Offset centerOffset) {
    var textStyle =
        TextStyle(color: textColor, fontSize: 140, fontWeight: FontWeight.bold);
    var textSpan = TextSpan(
      text: '$currentSpeed',
      style: textStyle,
    );
    var textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    var xCenter = (size.width - textPainter.width) / 2;
    var yCenter = (size.height - textPainter.height) / 2;
    var offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);

    textStyle = TextStyle(
      color: textColor,
      fontSize: 24,
    );
    textSpan = TextSpan(
      text: 'MPH',
      style: textStyle,
    );
    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    xCenter = (size.width - textPainter.width) / 2;
    yCenter = (size.height - textPainter.height) / 2;
    offset = Offset(xCenter, yCenter + 80);

    textPainter.paint(canvas, offset);

    var startOffset = Offset(xCenter - 50.0, yCenter + 130);
    var endOffset = Offset(xCenter + 110.0, yCenter + 130);

    final gradient = LinearGradient(
      colors: <Color>[
        Colors.white.withOpacity(0.0),
        Colors.white.withOpacity(0.5),
        Colors.white.withOpacity(0.0),
      ],
      stops: const [
        0.0,
        0.5,
        1.0,
      ],
    );

    var rect = Rect.fromLTWH(xCenter - 40.0, yCenter + 130, 160, 2);
    var tmpPaint = Paint()..shader = gradient.createShader(rect);

    offset = Offset(xCenter, yCenter + 150.0);
    canvas.drawLine(startOffset, endOffset, tmpPaint);
    offset = Offset(xCenter - 30.0, yCenter + 150.0);
    canvas.drawImage(image!, offset, Paint());

    textStyle = TextStyle(
      color: textColor,
      fontSize: 42,
      fontWeight: FontWeight.bold,
    );
    textSpan = TextSpan(
      text: '34',
      style: textStyle,
    );
    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    xCenter = (size.width - textPainter.width) / 2;
    yCenter = (size.height + 150 - textPainter.height) / 2;
    offset = Offset(xCenter + 2, yCenter + 73);

    textPainter.paint(canvas, offset);

    textStyle = TextStyle(
      color: textColor,
      fontSize: 16,
    );
    textSpan = TextSpan(
      text: 'MPH',
      style: textStyle,
    );
    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    xCenter = (size.width - textPainter.width) / 2;
    yCenter = (size.height + 150 - textPainter.height) / 2;
    offset = Offset(xCenter + 50.0, yCenter + 72);

    textPainter.paint(canvas, offset);
  }

  drawGears(Canvas canvas, Size size, Offset centerOffset) {
    var defaultGearTextStyle =
        TextStyle(color: bgColor, fontSize: 16, fontWeight: FontWeight.bold);
    var selectedGearTextStyle =
        TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold);
    var textSpan = TextSpan(
      text: '',
      style: selectedGearTextStyle,
    );
    var textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    var gearSelectedCirclePaint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt;
    var gearTextArcRadius = min(size.width / 2, size.height / 2) + 70.0;
    var gearStartDegree = -210.0;
    var gearStepDegree = 15.0;
    var gearEndDegree = gearStartDegree + gearStepDegree * 5;
    var gearNames = <String>['B', 'P', 'D', 'N', 'R'];
    var counter = 0;
    for (var i = 0; i < 5; i++) {
      var arc = ArcObject(
          center: centerOffset,
          startAngle: gearStartDegree + (gearStepDegree * i),
          endAngle: gearStartDegree + (gearStepDegree * i),
          radius: gearTextArcRadius);
      if (counter == currentGear) {
        textSpan = TextSpan(
          text: gearNames[counter],
          style: selectedGearTextStyle,
        );
      } else {
        textSpan = TextSpan(
          text: gearNames[counter],
          style: defaultGearTextStyle,
        );
      }

      textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center);
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      var offset = Offset(arc.arcPoints!.startX - textPainter.width / 2,
          arc.arcPoints!.startY - textPainter.height / 2);
      textPainter.paint(canvas, offset);
      offset = Offset(arc.arcPoints!.startX, arc.arcPoints!.startY);
      if (counter == currentGear) {
        canvas.drawCircle(offset, 30.0, gearSelectedCirclePaint);
      }
      counter++;
    }
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
        var endAngleX =
            startAngle + valueToDegree(currentValue, endAngle - startAngle);

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
      var endValueTemp = i == arcAngles.length - 1 ? endValue : sum + parts[i];

      var startAngleTemp = arcAngles[i].start;
      var endAngleTemp = arcAngles[i].end;

      if (currentValue >= startValueTemp && currentValue <= endValueTemp) {
        var endAngleX =
            startAngle + valueToDegree(currentValue, endAngle - startAngle);

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
    required this.fillDirection,
    required this.startCapShape,
    required this.endCapShape,
  }) {
    outerArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.5 * width / 100),
      endAngle: endAngle - (3.5 * width / 100),
      radius: radius,
    );
    outerHelperArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.3 * width / 100),
      endAngle: endAngle - (3.3 * width / 100),
      radius: radius - (width * 1 / 100),
    );
    centerOuterArc = ArcObject(
      center: center,
      startAngle: startAngle + (2.5 * width / 100),
      endAngle: endAngle - (2.5 * width / 100),
      radius: radius - (width * 10 / 100),
    );
    centerArc = ArcObject(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      radius: radius - (width / 2),
    );
    centerInnerArc = ArcObject(
      center: center,
      startAngle: startAngle + (2.5 * width / 100),
      endAngle: endAngle - (2.5 * width / 100),
      radius: radius - width + (width * 10 / 100),
    );
    innerHelperArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.3 * width / 100),
      endAngle: endAngle - (3.3 * width / 100),
      radius: radius - width + (width * 1 / 100),
    );
    innerArc = ArcObject(
      center: center,
      startAngle: startAngle + (3.5 * width / 100),
      endAngle: endAngle - (3.5 * width / 100),
      radius: radius - width,
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

  ArcObject({
    required this.center,
    required this.startAngle,
    required this.endAngle,
    required this.radius,
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
