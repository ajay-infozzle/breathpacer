import 'package:flutter/material.dart';

import 'colors.dart';

@immutable
class AppTheme {
  static const colors = AppColors();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: "ProximaNova",
      primaryColor: const Color(0xFF6A55E3),
    );
  }
}
