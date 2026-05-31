import 'package:flutter_test/flutter_test.dart';
import 'package:letterpress/design_system/design_system.dart';
import 'package:letterpress/letterpress-engine/store/remote_content.dart';
import 'package:letterpress/letterpress-engine/store/remote_markdown_parser.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('LPRemoteMarkdownParser parses custom markdown blocks', () {
    final List<LPPostComponent> components = LPRemoteMarkdownParser.parse('''
Remote Article Title

# Overview
Hello [world](https://example.com).

@img {
  url: https://example.com/cover.png
  width: 640
  height: 360
}

- one
- two

```dart
print("hi");
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

    expect(components.first, isA<LPText>());
    expect((components.first as LPText).content, 'Overview');
    expect(components.whereType<LPImage>(), hasLength(1));
    expect(components.whereType<LPSingleLevelListSpan>(), hasLength(1));
    expect(components.whereType<LPCodeBlock>(), hasLength(1));
    expect(components.whereType<LPDivider>(), hasLength(1));
    expect(components.whereType<LPVerseQuote>(), hasLength(1));
  });

  test('LPRemoteContentResolver uses fetched markdown when available',
      () async {
    final LPModule article = LPModule(
      title: 'Remote Blogule',
      publicationDate: DateTime(2026, 1, 1),
      lastUpdate: DateTime(2026, 1, 2),
      includeTableOfContents: true,
      components: <LPPostComponent>[LPText.plainBody(content: 'Fallback copy')],
      tags: const <String>['flutter'],
      projectName: 'letterpress',
      renderWithPost: false,
    );

    final LPResolvedArticlePayload payload =
        await LPRemoteContentResolver.resolveArticle(
      article: article,
      markdownSourceUrl: 'https://example.com/blogules/remote_blogule.md',
      fetcher: (_) async => '''
Remote Blogule

# Intro
Fetched body copy.
''',
      useCache: false,
    );

    expect(payload.loadedFromRemote, isTrue);
    expect(payload.article.components.first, isA<LPText>());
    expect((payload.article.components.first as LPText).content, 'Intro');
  });

  test('LPRemoteContentResolver falls back to embedded components on error',
      () async {
    final LPModule article = LPModule(
      title: 'Fallback Blogule',
      publicationDate: DateTime(2026, 1, 1),
      lastUpdate: DateTime(2026, 1, 2),
      includeTableOfContents: false,
      components: <LPPostComponent>[LPText.plainBody(content: 'Fallback copy')],
      tags: const <String>[],
      projectName: 'letterpress',
      renderWithPost: false,
    );

    final LPResolvedArticlePayload payload =
        await LPRemoteContentResolver.resolveArticle(
      article: article,
      markdownSourceUrl: 'https://example.com/blogules/fallback_blogule.md',
      fetcher: (_) async => throw StateError('network failed'),
      useCache: false,
    );

    expect(payload.loadedFromRemote, isFalse);
    expect(payload.error, isA<StateError>());
    expect(payload.article.components, hasLength(1));
    expect(
        (payload.article.components.first as LPText).content, 'Fallback copy');
  });
}
