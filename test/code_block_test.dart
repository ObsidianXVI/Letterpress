@TestOn('browser')
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:letterpress/design_system/design_system.dart';

import 'test_harness.dart';

void main() {
  setUpAll(initTestPlatform);

  group('LPHighlighter', () {
    test('splits a known language into styled spans', () {
      final TextSpan span = LPHighlighter.highlight(
        source: 'final int answer = 42;',
        lang: 'dart',
        baseStyle: const TextStyle(fontSize: 14),
      );
      // A highlighted result is a tree of spans; unhighlighted text would come
      // back as a single span carrying the whole source.
      expect(span.children, isNotNull);
      expect(span.children!.length, greaterThan(1));
      expect(span.toPlainText(), 'final int answer = 42;');
    });

    test('falls back to a single unstyled span for unknown languages', () {
      const String source = 'not a real language {{{';
      final TextSpan span = LPHighlighter.highlight(
        source: source,
        lang: 'plain',
        baseStyle: const TextStyle(fontSize: 14),
      );
      expect(span.children, isNull);
      expect(span.text, source);
    });

    test('preserves source text exactly for every registered language', () {
      const String source = 'x = 1';
      for (final String lang in LPHighlighter.languages.keys) {
        final TextSpan span = LPHighlighter.highlight(
          source: source,
          lang: lang,
          baseStyle: const TextStyle(fontSize: 14),
        );
        expect(span.toPlainText(), source, reason: 'language: $lang');
      }
    });

    test('aliases resolve to the same grammar as their canonical name', () {
      expect(LPHighlighter.supports('js'), isTrue);
      expect(LPHighlighter.supports('JS'), isTrue);
      expect(LPHighlighter.supports('yml'), isTrue);
      expect(LPHighlighter.supports('brainfuck'), isFalse);
    });
  });

  group('LPCodeBlock', () {
    testWidgets('numbers every line', (tester) async {
      await pumpInApp(
        tester,
        const SizedBox(
          width: 600,
          child: LPCodeBlock(content: 'one\ntwo\nthree', lang: 'plain'),
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsNothing);
    });

    testWidgets('drops trailing blank lines from the gutter', (tester) async {
      // Snippets are written as Dart string literals, which almost always leave
      // a trailing newline that is not part of the code.
      await pumpInApp(
        tester,
        const SizedBox(
          width: 600,
          child: LPCodeBlock(content: 'one\ntwo\n\n\n'),
        ),
      );
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsNothing);
    });

    testWidgets('pads line numbers to a consistent width', (tester) async {
      await pumpInApp(
        tester,
        SizedBox(
          width: 600,
          child: LPCodeBlock(
            content: List<String>.generate(12, (i) => 'line $i').join('\n'),
          ),
        ),
      );
      // Two-digit file, so single digits are right-aligned with a leading space.
      expect(find.text(' 1'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('offers a copy action and confirms it', (tester) async {
      // The browser refuses real clipboard writes in a test harness, so the
      // platform channel is stubbed to isolate the widget's own behaviour.
      final List<String> written = [];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall call) async {
          if (call.method == 'Clipboard.setData') {
            written.add((call.arguments as Map)['text'] as String);
          }
          return null;
        },
      );
      addTearDown(() => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null));

      await pumpInApp(
        tester,
        const SizedBox(
          width: 600,
          child: LPCodeBlock(content: 'copy me', lang: 'dart'),
        ),
      );

      expect(find.text('Copy'), findsOneWidget);
      await tester.tap(find.text('Copy'));
      await tester.pump();
      expect(find.text('Copied'), findsOneWidget);

      expect(written, ['copy me']);

      // The confirmation reverts on a timer; let it elapse so the test does not
      // end with it still pending.
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Copy'), findsOneWidget);
    });

    testWidgets('shows language and provenance when given', (tester) async {
      await pumpInApp(
        tester,
        const SizedBox(
          width: 600,
          child: LPCodeBlock(
            content: 'void main() {}',
            lang: 'dart',
            provenance: 'lib/main.dart',
          ),
        ),
      );
      expect(find.text('dart'), findsOneWidget);
      expect(find.text('lib/main.dart'), findsOneWidget);
    });

    testWidgets('hides the language chip for plain snippets', (tester) async {
      await pumpInApp(
        tester,
        const SizedBox(width: 600, child: LPCodeBlock(content: 'hello')),
      );
      expect(find.text('plain'), findsNothing);
    });

    testWidgets('renders without overflow on a narrow phone', (tester) async {
      await pumpInApp(
        tester,
        const LPCodeBlock(
          content:
              'a very long line of source code that will not fit inside a phone viewport at all',
          lang: 'dart',
        ),
        size: TestViewports.smallPhone,
      );
      // A RenderFlex overflow would have been recorded as an exception.
      expect(tester.takeException(), isNull);
    });
  });
}
