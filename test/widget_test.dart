import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:letterpress/design_system/design_system.dart';
import 'package:letterpress/letterpress-engine/store/lp_store.dart';
import 'package:letterpress/main.dart';

void main() {
  setUp(() {
    initializeLetterpressPlatforms();
  });

  testWidgets(
    'blogule detail pages resolve while the blogules index falls back home',
    (WidgetTester tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      tester.view
        ..physicalSize = const Size(1440, 960)
        ..devicePixelRatio = 1;

      await tester.pumpWidget(
        LetterpressRootApp(initialRoute: LPRoutes.lp_blogules),
      );
      await tester.pumpAndSettle();

      expect(find.text('LET\nTER\nPRESS'), findsOneWidget);

      await tester.pumpWidget(
        LetterpressRootApp(
          initialRoute:
              "${LPRoutes.lp_blogules}/${LPStore.blogules.first.slug}",
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(LPStore.blogules.first.title), findsWidgets);
    },
  );

  testWidgets('LPTextSpan participates in SelectionArea selection', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SelectionArea(
            child: LPTextSpan(
              lpTextComponents: [
                LPText.plainBody(content: 'Selectable '),
                LPText.codeStyle(content: 'inline_code', inline: true),
                LPText.plainBody(content: ' works.'),
              ],
            ),
          ),
        ),
      ),
    );

    final RichText richText = tester.widget<RichText>(
      find.descendant(
        of: find.byType(LPTextSpan),
        matching: find.byType(RichText),
      ),
    );

    expect(richText.selectionRegistrar, isNotNull);
  });

  testWidgets('PromoCard grows with wider available space', (
    WidgetTester tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    const Key promoCardSurfaceKey = Key('promo-card-surface');

    Future<Size> pumpCard(Size viewportSize) async {
      tester.view
        ..physicalSize = viewportSize
        ..devicePixelRatio = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PromoCard(
              size: SizeVariant.large,
              article: LPStore.posts.first,
              description: LPStore.posts.first.description,
              onTap: () {},
              surfaceKey: promoCardSurfaceKey,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      return tester.getSize(find.byKey(promoCardSurfaceKey));
    }

    final Size narrowSize = await pumpCard(const Size(420, 900));
    final Size wideSize = await pumpCard(const Size(1440, 900));

    expect(wideSize.width, greaterThan(narrowSize.width));
    expect(wideSize.height, greaterThan(narrowSize.height));
  });
}
