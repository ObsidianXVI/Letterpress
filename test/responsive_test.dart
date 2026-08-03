@TestOn('browser')
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:letterpress/design_system/design_system.dart';
import 'package:letterpress/utils/utils.dart';
import 'package:octane/octane_ds/octane_ds.dart';
import 'package:project_redline/multi_platform/multi_platform.dart';

import 'test_harness.dart';

void main() {
  setUpAll(initTestPlatform);

  group('LPBreakpoints', () {
    test('every viewport resolves to a supported layout', () {
      // The old selector rejected anything outside two narrow bands and showed
      // an error page instead. Nothing may fall through any more.
      const List<Size> sizes = [
        Size(320, 568),
        Size(390, 844),
        Size(768, 1024),
        Size(899, 600),
        Size(900, 600),
        Size(1440, 900),
        Size(1920, 1080),
        Size(2560, 1440),
        Size(100, 100),
      ];
      for (final Size size in sizes) {
        final DetectedPlatform platform =
            LPBreakpoints.select(size.width, size.height);
        expect(
          platform == const MobilePlatform() ||
              platform == const DesktopPlatform(),
          isTrue,
          reason: '$size resolved to $platform',
        );
      }
    });

    test('splits at the documented width, regardless of height', () {
      expect(LPBreakpoints.select(899, 400), const MobilePlatform());
      expect(LPBreakpoints.select(899, 2000), const MobilePlatform());
      expect(LPBreakpoints.select(900, 400), const DesktopPlatform());
      expect(LPBreakpoints.select(900, 2000), const DesktopPlatform());
    });
  });

  group('lpScaled', () {
    test('clamps the scale factor at both extremes', () {
      // Unclamped, a 2560px monitor would scale desktop type by 1.78 and a
      // 900px window would shrink it to 0.63.
      Multiplatform.currentPlatform = const DesktopPlatform();

      final double atBase = _scaledAtWidth(20, 1440);
      final double atWide = _scaledAtWidth(20, 2560);
      final double atNarrow = _scaledAtWidth(20, 900);

      expect(atBase, closeTo(20, 0.01));
      expect(atWide, closeTo(20 * 1.15, 0.01));
      expect(atNarrow, closeTo(20 * 0.9, 0.01));
    });

    test('honours the minimum floor', () {
      Multiplatform.currentPlatform = const MobilePlatform();
      expect(_scaledAtWidth(10, 320, min: 14), 14);
    });
  });

  group('LPText outline levels', () {
    test('headings carry a depth and body text does not', () {
      expect(LPText.mainTitle(content: 'a').headerLevel, 1);
      expect(LPText.header1(content: 'a').headerLevel, 2);
      expect(LPText.header2(content: 'a').headerLevel, 3);
      expect(LPText.header3(content: 'a').headerLevel, 4);

      expect(LPText.plainBody(content: 'a').headerLevel, 0);
      expect(LPText.plainBody(content: 'a').isHeader, isFalse);
      expect(LPText.header1(content: 'a').isHeader, isTrue);
    });

    test('style is resolved per read, not frozen at construction', () {
      // Articles are built once into a static store, so a style captured in the
      // constructor would pin the whole site to the first viewport seen.
      final LPText text = LPText.plainBody(content: 'hello');

      Multiplatform.currentPlatform = const MobilePlatform();
      final double? mobileSize = text.lpFont.fontSize;

      Multiplatform.currentPlatform = const DesktopPlatform();
      final double? desktopSize = text.lpFont.fontSize;

      expect(mobileSize, isNotNull);
      expect(desktopSize, isNotNull);
      expect(desktopSize, isNot(equals(mobileSize)));
    });
  });

  group('LPViewport', () {
    testWidgets('publishes the platform matching the viewport', (tester) async {
      late LPViewportData seen;
      await pumpInApp(
        tester,
        Builder(builder: (context) {
          seen = LPViewport.of(context);
          return const SizedBox.shrink();
        }),
        size: TestViewports.phone,
      );
      expect(seen.isMobile, isTrue);
      expect(seen.pick(mobile: 'm', desktop: 'd'), 'm');
    });

    testWidgets('rebuilds dependents when the viewport crosses a breakpoint',
        (tester) async {
      final List<bool> observed = [];
      await pumpInApp(
        tester,
        Builder(builder: (context) {
          observed.add(LPViewport.of(context).isMobile);
          return const SizedBox.shrink();
        }),
        size: TestViewports.phone,
      );
      expect(observed.last, isTrue);

      setViewport(tester, TestViewports.laptop);
      await tester.pumpAndSettle();

      expect(observed.last, isFalse,
          reason: 'dependent should have rebuilt as desktop');
    });
  });
}

/// Evaluates [lpScaled] as though the viewport were [width] wide.
double _scaledAtWidth(double base, double width, {double min = 0}) {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  binding.platformDispatcher.views.first.physicalSize = Size(width, 900);
  binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  final double result = lpScaled(base, min: min);
  binding.platformDispatcher.views.first.resetPhysicalSize();
  binding.platformDispatcher.views.first.resetDevicePixelRatio();
  return result;
}
