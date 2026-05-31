import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('md2lp CLI', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('md2lp_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('module command emits LPModule class and declaration', () async {
      final File markdownFile = File('${tempDir.path}/article.md');
      await markdownFile.writeAsString('''
Openly Open-Source

# Overview
<TOC>
This is a [link](https://example.com).

@img {
  url: https://example.com/image.png
  width: 640
  height: 360
}

```dart
print("hello");
```

@div

@versequote {
  artist: Logic
  song: Playwright
  album: College Park
  hyperlink: https://example.com/track
  verses: [
    first line
    second line
  ]
}
''');

      final ProcessResult result = await Process.run(
        Platform.resolvedExecutable,
        <String>[
          'run',
          'bin/md2lp.dart',
          'module',
          '--input',
          markdownFile.path,
          '--publication-date',
          '2024-11-23',
          '--last-update',
          '2025-03-16',
          '--project-name',
          'affogato',
          '--cover-img-name',
          'Infinitude',
          '--preview',
        ],
        workingDirectory: Directory.current.path,
      );

      expect(result.exitCode, 0, reason: '${result.stderr}');
      final String output = result.stdout as String;
      expect(output, contains('class Openly_Open_Source extends LPModule'));
      expect(output, contains('includeTableOfContents: true'));
      expect(output, contains('LPText.header1(content: "Overview")'));
      expect(output, contains('LPImage.url('));
      expect(output, contains('LPCodeBlock(content: "print(\\"hello\\");"'));
      expect(output, contains('LPVerseQuote('));
      expect(
        output,
        contains('final LPModule openly_open_source = Openly_Open_Source('),
      );
      expect(output, contains('isPreviewMode: true'));
    });

    test('post command emits LPPost declaration', () async {
      final ProcessResult result = await Process.run(
        Platform.resolvedExecutable,
        <String>[
          'run',
          'bin/md2lp.dart',
          'post',
          '--title',
          'Build-In-Public: Developing a complex BaaS from scratch',
          '--description',
          'Cortado is a plug-and-play backend-as-a-service.',
          '--publication-date',
          '2026-05-02',
          '--last-update',
          '2026-05-03',
          '--blogules',
          'cortado_initial_post,openly_open_source',
          '--preview',
        ],
        workingDirectory: Directory.current.path,
      );

      expect(result.exitCode, 0, reason: '${result.stderr}');
      final String output = result.stdout as String;
      expect(
          output,
          contains(
              'final LPPost build_in_public_developing_a_complex_baas_from_scratch = LPPost('));
      expect(output,
          contains('blogules: [cortado_initial_post, openly_open_source]'));
      expect(output, contains('isPreviewMode: true'));
    });
  });
}
