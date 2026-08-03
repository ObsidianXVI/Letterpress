import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:letterpress/design_system/design_system.dart';
import 'package:letterpress/utils/utils.dart';
import 'package:project_redline/multi_platform/multi_platform.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Common viewport sizes used across the suite.
class TestViewports {
  const TestViewports._();

  static const Size phone = Size(390, 844);
  static const Size smallPhone = Size(320, 568);
  static const Size tablet = Size(834, 1112);
  static const Size laptop = Size(1440, 900);
  static const Size wideMonitor = Size(2560, 1440);
}

/// Initialises the multiplatform layer exactly once per test isolate.
///
/// [Multiplatform.baseStyle] is `late final`, so a second `init` would throw.
void initTestPlatform() {
  Multiplatform.init(
    platformSelector: LPBreakpoints.select,
    baseStyle: const TextStyle(fontFamily: 'Fraunces_Standard'),
  );
  // VisibilityDetector batches its callbacks behind a 500ms timer, which
  // outlives the widget tree and fails the test as a pending timer. Firing
  // immediately keeps the cover-visibility logic testable.
  VisibilityDetectorController.instance.updateInterval = Duration.zero;
}

/// Sizes the test view and keeps the global platform in step.
///
/// `lpScaled` reads the raw view through `Dimensions`, not `MediaQuery`, so the
/// physical size has to be set as well as the widget-level constraints or the
/// type scale under test would not match the layout under test.
void setViewport(WidgetTester tester, Size size, {double pixelRatio = 1.0}) {
  tester.view.devicePixelRatio = pixelRatio;
  tester.view.physicalSize = size * pixelRatio;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  Multiplatform.currentPlatform =
      LPBreakpoints.select(size.width, size.height);
}

/// Pumps [child] inside the same scaffolding the real app provides.
Future<void> pumpInApp(
  WidgetTester tester,
  Widget child, {
  Size size = TestViewports.laptop,
}) async {
  setViewport(tester, size);
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, built) => LPViewport(child: built!),
      home: Material(child: child),
    ),
  );
  await tester.pump();
}
