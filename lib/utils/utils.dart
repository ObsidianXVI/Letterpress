library letterpress.utils;

import 'package:flutter/material.dart';
import 'package:octane/octane_ds/octane_ds.dart';
import 'package:project_redline/multi_platform/multi_platform.dart';

/// Viewport thresholds that decide which layout the site renders.
///
/// Letterpress ships two layouts, mobile and desktop, and every viewport must
/// resolve to one of them — there is no "unsupported viewport" state. Only the
/// width is consulted: height varies far too much across browser chrome,
/// on-screen keyboards and desktop window shapes to be a reliable signal.
class LPBreakpoints {
  const LPBreakpoints._();

  /// Viewports narrower than this render the mobile layout.
  ///
  /// 900 sits above every phone in portrait and above most tablets in
  /// portrait, while staying below a comfortably sized desktop window. The
  /// desktop layout needs the extra width for its side-note gutters, which
  /// stop being usable below roughly this point.
  static const double desktopMinWidth = 900;

  static DetectedPlatform select(double width, double height) => width <
          desktopMinWidth
      ? const MobilePlatform()
      : const DesktopPlatform();
}

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
