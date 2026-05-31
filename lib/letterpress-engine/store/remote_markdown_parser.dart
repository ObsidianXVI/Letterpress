library letterpress.remote_markdown_parser;

import 'package:letterpress/design_system/design_system.dart';
import 'package:markdown/markdown.dart' as md;

class LPRemoteMarkdownParser {
  static List<LPPostComponent> parse(String source) {
    final String normalized = source.replaceAll('\r\n', '\n').trim();
    if (normalized.isEmpty) {
      return const <LPPostComponent>[];
    }

    final List<String> lines = normalized.split('\n');
    while (lines.isNotEmpty && lines.first.trim().isEmpty) {
      lines.removeAt(0);
    }
    if (lines.isNotEmpty && !_looksLikeMarkdownBlock(lines.first.trim())) {
      lines.removeAt(0);
    }

    final List<md.Node> nodes = md.Document(
      extensionSet: md.ExtensionSet.gitHubFlavored,
      blockSyntaxes: <md.BlockSyntax>[
        _VerseQuoteBlockSyntax(),
        _ImageBlockSyntax(),
        _DividerBlockSyntax(),
      ],
    ).parse(lines.join('\n'));

    final List<LPPostComponent> components = <LPPostComponent>[];
    for (final md.Node node in nodes) {
      components.addAll(_convertBlockNode(node));
    }
    return components;
  }

  static bool _looksLikeMarkdownBlock(String line) {
    return line.startsWith('#') ||
        line.startsWith('>') ||
        line.startsWith('- ') ||
        line.startsWith('* ') ||
        line.startsWith('1.') ||
        line.startsWith('```') ||
        line.startsWith('@') ||
        line.startsWith('<');
  }

  static List<LPPostComponent> _convertBlockNode(md.Node node) {
    if (node is md.Text) {
      final String content = node.text.trim();
      return content.isEmpty
          ? const <LPPostComponent>[]
          : <LPPostComponent>[LPText.plainBody(content: content)];
    }

    if (node is! md.Element) {
      return const <LPPostComponent>[];
    }

    switch (node.tag) {
      case 'h1':
        return <LPPostComponent>[LPText.header1(content: _flattenText(node))];
      case 'h2':
        return <LPPostComponent>[LPText.header2(content: _flattenText(node))];
      case 'h3':
        return <LPPostComponent>[LPText.header3(content: _flattenText(node))];
      case 'p':
        final LPPostComponent? paragraph = _inlineComponent(node.children);
        return paragraph == null
            ? const <LPPostComponent>[]
            : <LPPostComponent>[paragraph];
      case 'blockquote':
        final String quote = _flattenText(node).trim();
        return quote.isEmpty
            ? const <LPPostComponent>[]
            : <LPPostComponent>[LPPullQuote(content: quote)];
      case 'ul':
        return <LPPostComponent>[
          LPSingleLevelListSpan(
            listType: LPListType.bullet,
            listItems: _convertListItems(node.children ?? const <md.Node>[]),
          ),
        ];
      case 'ol':
        return <LPPostComponent>[
          LPSingleLevelListSpan(
            listType: LPListType.numbered,
            listItems: _convertListItems(node.children ?? const <md.Node>[]),
          ),
        ];
      case 'pre':
        final md.Element? codeNode =
            node.children?.whereType<md.Element>().firstWhere(
                  (md.Element child) => child.tag == 'code',
                  orElse: () => md.Element.empty('code'),
                );
        final String languageClass = codeNode?.attributes['class'] ?? '';
        final String language = languageClass.startsWith('language-')
            ? languageClass.substring('language-'.length)
            : 'plain';
        final String content = _flattenText(codeNode ?? node);
        return <LPPostComponent>[
          LPCodeBlock(content: content.trimRight(), lang: language),
        ];
      case 'img':
        final String? url = node.attributes['url'];
        if (url == null || url.trim().isEmpty) {
          return const <LPPostComponent>[];
        }
        final double width =
            double.tryParse(node.attributes['width'] ?? '') ?? 800;
        final double height =
            double.tryParse(node.attributes['height'] ?? '') ?? 450;
        return <LPPostComponent>[
          LPImage.url(url: url, width: width, height: height),
        ];
      case 'versequote':
        final List<String> verses = (node.attributes['verses'] ?? '')
            .split('|')
            .map((String verse) => verse.trim())
            .where((String verse) => verse.isNotEmpty)
            .toList();
        if (verses.isEmpty) {
          return const <LPPostComponent>[];
        }
        final String artist = (node.attributes['artist'] ?? '').trim();
        final String song = (node.attributes['song'] ?? '').trim();
        final String album = (node.attributes['album'] ?? '').trim();
        final String? hyperlink =
            (node.attributes['hyperlink'] ?? '').trim().isEmpty
                ? null
                : node.attributes['hyperlink']!.trim();
        final List<String> referenceParts = <String>[
          if (artist.isNotEmpty) artist,
          if (song.isNotEmpty) song,
          if (album.isNotEmpty) '($album)',
        ];
        return <LPPostComponent>[
          LPVerseQuote(
            verses: verses,
            reference: referenceParts.join(', ').replaceAll(', (', ' ('),
            url: hyperlink,
          ),
        ];
      case 'div':
      case 'hr':
        return const <LPPostComponent>[LPDivider()];
      default:
        final List<LPPostComponent> children = <LPPostComponent>[];
        for (final md.Node child in node.children ?? const <md.Node>[]) {
          children.addAll(_convertBlockNode(child));
        }
        return children;
    }
  }

  static List<LPPostComponent> _convertListItems(List<md.Node> children) {
    final List<LPPostComponent> items = <LPPostComponent>[];
    for (final md.Node child in children) {
      if (child is! md.Element || child.tag != 'li') {
        continue;
      }

      final LPPostComponent? item = _inlineComponent(child.children);
      if (item != null) {
        items.add(item);
        continue;
      }

      final List<LPPostComponent> blocks = <LPPostComponent>[];
      for (final md.Node nested in child.children ?? const <md.Node>[]) {
        blocks.addAll(_convertBlockNode(nested));
      }
      if (blocks.isEmpty) {
        continue;
      }
      if (blocks.length == 1) {
        items.add(blocks.first);
      } else {
        items.add(LPGroup.vertical(postComponents: blocks));
      }
    }
    return items;
  }

  static LPPostComponent? _inlineComponent(List<md.Node>? children) {
    final List<LPText> spans =
        _convertInlineNodes(children ?? const <md.Node>[]);
    if (spans.isEmpty) {
      return null;
    }

    return LPTextSpan(lpTextComponents: spans);
  }

  static List<LPText> _convertInlineNodes(List<md.Node> nodes) {
    final List<LPText> spans = <LPText>[];

    for (final md.Node node in nodes) {
      if (node is md.Text) {
        if (node.text.isNotEmpty) {
          spans.add(LPText.plainBody(content: node.text));
        }
        continue;
      }

      if (node is! md.Element) {
        continue;
      }

      switch (node.tag) {
        case 'a':
          spans.add(
            LPText.hyperlink(
              content: _flattenText(node),
              url: node.attributes['href'],
            ),
          );
          break;
        case 'code':
          spans.add(
            LPText.codeStyle(
              content: _flattenText(node),
              inline: true,
            ),
          );
          break;
        case 'em':
          spans.add(
              LPText.plainBody(content: _flattenText(node), isItalic: true));
          break;
        case 'strong':
          spans
              .add(LPText.plainBody(content: _flattenText(node), isBold: true));
          break;
        case 'del':
          spans.add(
            LPText.plainBody(
              content: _flattenText(node),
              isStrikethrough: true,
            ),
          );
          break;
        case 'br':
          spans.add(LPText.paragraphBreak());
          break;
        default:
          spans.addAll(_convertInlineNodes(node.children ?? const <md.Node>[]));
      }
    }

    return spans;
  }

  static String _flattenText(md.Node node) {
    if (node is md.Text) {
      return node.text;
    }
    if (node is! md.Element) {
      return '';
    }

    return (node.children ?? const <md.Node>[])
        .map<String>(_flattenText)
        .join();
  }
}

class _ImageBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^@img \{$');

  @override
  bool canParse(md.BlockParser parser) =>
      pattern.hasMatch(parser.current.content);

  @override
  md.Node? parse(md.BlockParser parser) {
    final Map<String, String> attrs = <String, String>{};
    while ((parser..advance()).current.content.trim() != '}') {
      final List<String> chunks = parser.current.content.split(':');
      if (chunks.length < 2) {
        continue;
      }
      attrs[chunks.first.trim()] = chunks.sublist(1).join(':').trim();
    }
    return md.Element.text('img', '')..attributes.addAll(attrs);
  }

  @override
  List<md.Line?> parseChildLines(md.BlockParser parser) => const <md.Line?>[];

  @override
  bool canEndBlock(md.BlockParser parser) => true;

  @override
  md.BlockSyntax? interruptedBy(md.BlockParser parser) => null;
}

class _DividerBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^@div$');

  @override
  bool canParse(md.BlockParser parser) =>
      pattern.hasMatch(parser.current.content.trim());

  @override
  md.Node? parse(md.BlockParser parser) => md.Element.text('div', '');

  @override
  List<md.Line?> parseChildLines(md.BlockParser parser) => const <md.Line?>[];

  @override
  bool canEndBlock(md.BlockParser parser) => true;

  @override
  md.BlockSyntax? interruptedBy(md.BlockParser parser) => null;
}

class _VerseQuoteBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^@versequote \{$');

  @override
  bool canParse(md.BlockParser parser) =>
      pattern.hasMatch(parser.current.content);

  @override
  md.Node? parse(md.BlockParser parser) {
    final Map<String, String> attrs = <String, String>{};

    while ((parser..advance()).current.content.trim() != '}') {
      final String line = parser.current.content.trim();
      if (line.isEmpty) {
        continue;
      }

      final List<String> chunks = line.split(':');
      final String key = chunks.first.trim();
      final String value = chunks.sublist(1).join(':').trim();
      if (key != 'verses') {
        attrs[key] = value;
        continue;
      }

      final List<String> verses = <String>[];
      while ((parser..advance()).current.content.trim() != ']') {
        final String verse = parser.current.content.trim();
        if (verse.isNotEmpty) {
          verses.add(verse);
        }
      }
      attrs['verses'] = verses.join('|');
    }

    return md.Element.text('versequote', '')..attributes.addAll(attrs);
  }

  @override
  List<md.Line?> parseChildLines(md.BlockParser parser) => const <md.Line?>[];

  @override
  bool canEndBlock(md.BlockParser parser) => true;

  @override
  md.BlockSyntax? interruptedBy(md.BlockParser parser) => null;
}
