import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UiConfigs{

  //font weights
  static FontWeight get thinFontWeight => FontWeight.w100;
  static FontWeight get extraLightFontWeight => FontWeight.w200;
  static FontWeight get lightFontWeight => FontWeight.w300;
  static FontWeight get regularFontWeight => FontWeight.w400;
  static FontWeight get mediumFontWeight => FontWeight.w500;
  static FontWeight get semiBoldFontWeight => FontWeight.w600;
  static FontWeight get boldFontWeight => FontWeight.w700;
  static FontWeight get extraBoldFontWeight => FontWeight.w800;
  static FontWeight get blackFontWeight => FontWeight.w900;

  //colors
  static Color get whiteTextColor => Colors.white;
  static Color get pageBackColor => const Color(0xFF303136);
  static Color get descriptionTextColor => const Color(0x99FFFFFF);
  static Color get backgroundColor => const Color(0xFF303136);
  static Color get titleTextColor => const Color(0xFFe4e5e9);
  static Color get indicatorTextColor => const Color(0xFF97969c);
  static Color get indicatorLineColor => const Color(0xFF47484f);
  static Color get speedOMeterTextColorInActive => const Color(0xFF6d6e77);
  static Color get speedOMeterTextColorActive => const Color(0xFFf4f5f8);
  static Color get speedOMeterCircleColorActive => const Color(0xFFd8e6ff);
  static Color get speedOMeterSpeedTextColor => const Color(0xFFffffff);
  static Color get speedOMeterSpeedUnitTextColor => const Color(0xFFf5f4fa);
  static Color get speedOMeterGreenLeafColor => const Color(0xFF79d26a);
  static Color get speedOMeterSpeedIndicatorColor => const Color(0xFFd0e0f3);
  static Color get speedOMeterSpeedIndicatorGlowColor => const Color(0xFFecf7ff);
  static Color get speedOMeterGasFuelGaugeIndicatorColor => const Color(0xFF6dbbb9);
  static Color get speedOMeterGasFuelGaugeIndicatorGlowColor => const Color(0xFFcfd2d6);
  static Color get speedOMeterPowerGaugeIndicatorColor => const Color(0xFF7394cc);
  static Color get speedOMeterPowerGaugeIndicatorGlowColor => const Color(0xFFf8ffff);
  static Color get speedOMeterFuelPowerIconColor => const Color(0xFFfdfefe);
  static Color get speedOMeterSpeedIndicatorBackgroundColor => const Color(0xFF414046);
  static Color get speedOMeterSpacerBelowSpeedMiddleColor => const Color(0xFF57585d);




  //styles
  static TextStyle get titleTextStyle => GoogleFonts.lato(
    textStyle: TextStyle(
      color: whiteTextColor,
      fontSize: 28.0,
      fontWeight: blackFontWeight,
      letterSpacing: -0.5,
    ),
  );

  static TextStyle get subTitleTextStyle => GoogleFonts.lato(
    textStyle: TextStyle(
      color: descriptionTextColor,
      fontSize: 16.0,
      fontWeight: boldFontWeight,
      letterSpacing: 0.2,
    ),
  );

  static TextStyle get normalTextStyle => GoogleFonts.lato(
    textStyle: TextStyle(
      color: pageBackColor,
      fontSize: 16.0,
      fontWeight: boldFontWeight,
      letterSpacing: 0.2,
    ),
  );
}