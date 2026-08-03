@TestOn('browser')
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:letterpress/design_system/design_system.dart';

import 'test_harness.dart';

/// A small article with a deliberate outline: two top-level headings, one of
/// which has a subsection.
LPModule buildArticle() => LPModule(
      title: 'Test Article',
      publicationDate: DateTime(2026, 1, 1),
      lastUpdate: DateTime(2026, 2, 1),
      includeTableOfContents: false,
      tags: const [],
      projectName: 'test',
      renderWithPost: false,
      components: [
        LPText.header1(content: 'Intro'),
        LPText.plainBody(content: 'Opening paragraph.'),
        LPText.header2(content: 'Some Background On This'),
        LPText.plainBody(content: 'Background paragraph.'),
        LPText.header1(content: 'Chapter 1'),
        LPText.plainBody(content: 'Chapter paragraph.'),
      ],
    );

void main() {
  setUpAll(initTestPlatform);

  group('article outline', () {
    test('collects one section per heading, in document order', () {
      final LPModule article = buildArticle();
      final List<LPArticleSection> sections = article.components
          .whereType<LPText>()
          .where((t) => t.isHeader)
          .map((t) => LPArticleSection(title: t.content, level: t.headerLevel))
          .toList();

      expect(sections.map((s) => s.title).toList(),
          ['Intro', 'Some Background On This', 'Chapter 1']);
      expect(sections.map((s) => s.level).toList(), [2, 3, 2]);
    });
  });

  group('RenderViewHeader breadcrumb', () {
    /// Builds the header and returns the trail it computes for [index].
    Future<List<String>> trailFor(WidgetTester tester, int? index) async {
      final LPModule article = buildArticle();
      final List<LPArticleSection> sections = article.components
          .whereType<LPText>()
          .where((t) => t.isHeader)
          .map((t) => LPArticleSection(title: t.content, level: t.headerLevel))
          .toList();

      await pumpInApp(
        tester,
        RenderViewHeader(
          vpWidth: 1440,
          article: article,
          sections: sections,
          currentSectionIndex: index,
          onSectionSelected: (_) {},
        ),
      );

      final RenderViewHeaderState state =
          tester.state(find.byType(RenderViewHeader));
      return state.breadcrumb.map((s) => s.title).toList();
    }

    testWidgets('is empty above the first heading', (tester) async {
      expect(await trailFor(tester, null), isEmpty);
    });

    testWidgets('a top-level heading stands alone', (tester) async {
      expect(await trailFor(tester, 0), ['Intro']);
    });

    testWidgets('a subsection keeps its parent', (tester) async {
      expect(await trailFor(tester, 1), ['Intro', 'Some Background On This']);
    });

    testWidgets('a later sibling does not inherit the previous subsection',
        (tester) async {
      expect(await trailFor(tester, 2), ['Chapter 1']);
    });

    testWidgets('shows a prompt when no section is current', (tester) async {
      await trailFor(tester, null);
      expect(find.text('Jump to section'), findsOneWidget);
    });

    testWidgets('renders the navigation menu button', (tester) async {
      await trailFor(tester, 0);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('hides the date on mobile to protect the breadcrumb',
        (tester) async {
      final LPModule article = buildArticle();
      await pumpInApp(
        tester,
        RenderViewHeader(
          vpWidth: 390,
          article: article,
          sections: const [],
          currentSectionIndex: null,
          onSectionSelected: (_) {},
        ),
        size: TestViewports.phone,
      );
      expect(find.textContaining('February'), findsNothing);
    });
  });

  group('LPRenderer', () {
    testWidgets('renders an article without layout overflow on a phone',
        (tester) async {
      await pumpInApp(
        tester,
        LPRenderer(article: buildArticle()),
        size: TestViewports.phone,
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders an article without layout overflow on a laptop',
        (tester) async {
      await pumpInApp(
        tester,
        LPRenderer(article: buildArticle()),
        size: TestViewports.laptop,
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('exposes every heading as a jumpable section', (tester) async {
      await pumpInApp(tester, LPRenderer(article: buildArticle()));
      final LPRendererState state = tester.state(find.byType(LPRenderer));
      expect(state.sections.length, 3);
      // Each section needs a live key or the header could not scroll to it.
      expect(state.sections.every((s) => s.key.currentContext != null), isTrue);
    });
  });

  group('selection', () {
    testWidgets('a view is wrapped in a single selection region',
        (tester) async {
      await pumpInApp(tester, LPRenderer(article: buildArticle()));
      // One region for the whole view is what allows a drag to cross paragraph
      // boundaries; per-widget SelectableTexts cannot do that.
      expect(find.byType(SelectableText), findsNothing);
    });

    testWidgets('body text is plain Text so the region owns selection',
        (tester) async {
      await pumpInApp(
        tester,
        LPSelectionArea(child: LPText.plainBody(content: 'selectable body')),
      );
      expect(find.byType(SelectionArea), findsOneWidget);
      expect(find.text('selectable body'), findsOneWidget);
      expect(find.byType(SelectableText), findsNothing);
    });
  });
}
