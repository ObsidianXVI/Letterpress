library letterpress.utils;

import 'package:flutter/material.dart';

class DimensionTools {
  static double getHeight(BuildContext context) {
    final padding = MediaQuery.of(context).viewPadding;
    final height = MediaQuery.of(context).size.height;
    return height - padding.top;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

extension StringUtils on String {
  String get urlSafeSlug =>
      toLowerCase().replaceAll(' ', '_').replaceAll(RegExp(r'[^\w\s]+'), '');
}
