library letterpress.utils;

import 'dart:ui';
import 'package:flutter/material.dart';

enum LPBreakpoint { compact, medium, expanded, wide }

abstract class LPPlatform {
  const LPPlatform();
}

class UnknownPlatform extends LPPlatform {
  const UnknownPlatform();
}

class MobilePlatform extends LPPlatform {
  const MobilePlatform();
}

class TabletPlatform extends LPPlatform {
  const TabletPlatform();
}

class DesktopPlatform extends LPPlatform {
  const DesktopPlatform();
}

class Multiplatform {
  static LPPlatform Function(double width, double height) platformSelector =
      _defaultPlatformSelector;
  static LPPlatform currentPlatform = const MobilePlatform();
  static TextStyle? baseStyle;

  static void init({
    required LPPlatform Function(double width, double height) platformSelector,
    TextStyle? baseStyle,
  }) {
    Multiplatform.platformSelector = platformSelector;
    Multiplatform.baseStyle = baseStyle;
    syncFromSize(Dimensions.width(), Dimensions.height());
  }

  static LPPlatform resolve(double width, double height) {
    return platformSelector(width, height);
  }

  static void syncFromSize(double width, double height) {
    currentPlatform = resolve(width, height);
  }

  static LPPlatform _defaultPlatformSelector(double width, double height) {
    if (width < 320 || height < 480) {
      return const UnknownPlatform();
    }
    if (width < 720) {
      return const MobilePlatform();
    }
    if (width < 1100) {
      return const TabletPlatform();
    }
    return const DesktopPlatform();
  }
}

class Dimensions {
  static FlutterView get _view =>
      WidgetsBinding.instance.platformDispatcher.views.first;

  static double width() => _view.physicalSize.width / _view.devicePixelRatio;

  static double height() => _view.physicalSize.height / _view.devicePixelRatio;
}

class LPAdaptiveInfo {
  final double width;
  final double height;
  final LPBreakpoint breakpoint;
  final LPPlatform platform;

  const LPAdaptiveInfo({
    required this.width,
    required this.height,
    required this.breakpoint,
    required this.platform,
  });

  factory LPAdaptiveInfo.fromSize(Size size) {
    final LPBreakpoint breakpoint = _breakpointForWidth(size.width);
    final LPPlatform platform = switch (breakpoint) {
      LPBreakpoint.compact => const MobilePlatform(),
      LPBreakpoint.medium => const TabletPlatform(),
      LPBreakpoint.expanded || LPBreakpoint.wide => const DesktopPlatform(),
    };

    return LPAdaptiveInfo(
      width: size.width,
      height: size.height,
      breakpoint: breakpoint,
      platform: platform,
    );
  }

  bool get isCompact => breakpoint == LPBreakpoint.compact;
  bool get isMedium => breakpoint == LPBreakpoint.medium;
  bool get isExpanded => breakpoint == LPBreakpoint.expanded;
  bool get isWide => breakpoint == LPBreakpoint.wide;
  bool get isMediumUp => breakpoint != LPBreakpoint.compact;
  bool get isExpandedUp =>
      breakpoint == LPBreakpoint.expanded || breakpoint == LPBreakpoint.wide;

  T pick<T>({required T compact, T? medium, T? expanded, T? wide}) {
    return switch (breakpoint) {
      LPBreakpoint.compact => compact,
      LPBreakpoint.medium => medium ?? expanded ?? wide ?? compact,
      LPBreakpoint.expanded => expanded ?? wide ?? medium ?? compact,
      LPBreakpoint.wide => wide ?? expanded ?? medium ?? compact,
    };
  }

  double fluid({
    required double min,
    required double max,
    double minWidth = 360,
    double maxWidth = 1440,
  }) {
    final double t = ((width - minWidth) / (maxWidth - minWidth)).clamp(
      0.0,
      1.0,
    );
    return lerpDouble(min, max, t)!;
  }
}

LPBreakpoint _breakpointForWidth(double width) {
  if (width < 720) {
    return LPBreakpoint.compact;
  }
  if (width < 1100) {
    return LPBreakpoint.medium;
  }
  if (width < 1440) {
    return LPBreakpoint.expanded;
  }
  return LPBreakpoint.wide;
}

extension LPAdaptiveContext on BuildContext {
  LPAdaptiveInfo get adaptive =>
      LPAdaptiveInfo.fromSize(MediaQuery.sizeOf(this));

  bool get isCompactLayout => adaptive.isCompact;
  bool get isMediumLayout => adaptive.isMedium;
  bool get isExpandedLayout => adaptive.isExpanded;
  bool get isWideLayout => adaptive.isWide;
  bool get isMediumUpLayout => adaptive.isMediumUp;
  bool get isDesktopLayout => adaptive.isExpandedUp;

  double fluid({
    required double min,
    required double max,
    double minWidth = 360,
    double maxWidth = 1440,
  }) =>
      adaptive.fluid(
        min: min,
        max: max,
        minWidth: minWidth,
        maxWidth: maxWidth,
      );
}

class LPAdaptiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, LPAdaptiveInfo adaptive) builder;

  const LPAdaptiveBuilder({required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return builder(context, context.adaptive);
  }
}

class ViewportSize extends StatelessWidget {
  final Widget child;

  const ViewportSize({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: child);
  }
}

double scaled(
  double desktop,
  double mobile, {
  double minWidth = 360,
  double maxWidth = 1440,
}) {
  final double t =
      ((Dimensions.width() - minWidth) / (maxWidth - minWidth)).clamp(0.0, 1.0);
  return lerpDouble(mobile, desktop, t)!;
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
