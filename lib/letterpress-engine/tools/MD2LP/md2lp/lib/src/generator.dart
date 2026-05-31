import 'dart:convert';

import 'package:markdown/markdown.dart' as md;

enum TocMode { auto, enabled, disabled }

class ModuleGenerationRequest {
  final String source;
  final DateTime publicationDate;
  final DateTime lastUpdate;
  final String projectName;
  final String? title;
  final String? className;
  final String? declarationName;
  final String? coverImgName;
  final List<String> tags;
  final bool previewMode;
  final String partOfLibrary;
  final TocMode tocMode;
  final bool emitDeclaration;

  const ModuleGenerationRequest({
    required this.source,
    required this.publicationDate,
    required this.lastUpdate,
    required this.projectName,
    this.title,
    this.className,
    this.declarationName,
    this.coverImgName,
    this.tags = const <String>[],
    this.previewMode = false,
    this.partOfLibrary = 'letterpress.store',
    this.tocMode = TocMode.auto,
    this.emitDeclaration = true,
  });
}

class ModuleGenerationResult {
  final String title;
  final String className;
  final String declarationName;
  final String fileContent;
  final bool includeTableOfContents;

  const ModuleGenerationResult({
    required this.title,
    required this.className,
    required this.declarationName,
    required this.fileContent,
    required this.includeTableOfContents,
  });
}

class PostGenerationRequest {
  final String title;
  final String description;
  final DateTime publicationDate;
  final DateTime lastUpdate;
  final List<String> bloguleDeclarations;
  final String? declarationName;
  final bool previewMode;

  const PostGenerationRequest({
    required this.title,
    required this.description,
    required this.publicationDate,
    required this.lastUpdate,
    required this.bloguleDeclarations,
    this.declarationName,
    this.previewMode = false,
  });
}

class MD2LPGenerator {
  ModuleGenerationResult generateModule(ModuleGenerationRequest request) {
    final _ParsedMarkdown parsed = _ParsedMarkdown.parse(request.source);
    final String resolvedTitle = request.title?.trim().isNotEmpty == true
        ? request.title!.trim()
        : parsed.title;

    if (resolvedTitle.isEmpty) {
      throw ArgumentError('A module title is required.');
    }

    final String resolvedClassName =
        request.className?.trim().isNotEmpty == true
            ? request.className!.trim()
            : _IdentifierTools.moduleClassNameFromTitle(resolvedTitle);
    final String resolvedDeclarationName =
        request.declarationName?.trim().isNotEmpty == true
            ? request.declarationName!.trim()
            : _IdentifierTools.declarationNameFromTitle(resolvedTitle);
    final bool includeTableOfContents = switch (request.tocMode) {
      TocMode.enabled => true,
      TocMode.disabled => false,
      TocMode.auto => parsed.includeTableOfContents,
    };

    final _ComponentEmitter emitter = _ComponentEmitter();
    final List<String> componentExpressions = emitter.emitAll(parsed.nodes);

    final StringBuffer buffer = StringBuffer()
      ..writeln('part of ${request.partOfLibrary};')
      ..writeln()
      ..writeln('class $resolvedClassName extends LPModule {')
      ..writeln('  $resolvedClassName({')
      ..writeln('    required bool renderWithPost,')
      ..writeln('    bool isPreviewMode = false,')
      ..writeln('  }) : super(')
      ..writeln('         isPreviewMode: isPreviewMode,')
      ..writeln('         title: ${_literal(resolvedTitle)},');

    if (request.coverImgName?.trim().isNotEmpty == true) {
      buffer.writeln(
        '         coverImgName: ${_literal(request.coverImgName!.trim())},',
      );
    }

    buffer
      ..writeln(
        '         lastUpdate: ${_dateLiteral(request.lastUpdate)},',
      )
      ..writeln(
        '         publicationDate: ${_dateLiteral(request.publicationDate)},',
      )
      ..writeln('         tags: ${_listLiteral(request.tags)},')
      ..writeln(
        '         includeTableOfContents: $includeTableOfContents,',
      )
      ..writeln('         components: [');

    for (final String component in componentExpressions) {
      buffer.writeln(_indent(component, 5));
      if (!component.trimRight().endsWith(',')) {
        buffer.writeln(',');
      }
    }

    buffer
      ..writeln('         ],')
      ..writeln('         projectName: ${_literal(request.projectName)},')
      ..writeln('         renderWithPost: renderWithPost,')
      ..writeln('       );')
      ..writeln('}');

    if (request.emitDeclaration) {
      buffer
        ..writeln()
        ..writeln(
            'final LPModule $resolvedDeclarationName = $resolvedClassName(')
        ..writeln('  renderWithPost: false,')
        ..writeln('  isPreviewMode: ${request.previewMode},')
        ..writeln(');');
    }

    return ModuleGenerationResult(
      title: resolvedTitle,
      className: resolvedClassName,
      declarationName: resolvedDeclarationName,
      fileContent: buffer.toString(),
      includeTableOfContents: includeTableOfContents,
    );
  }

  String generatePostDeclaration(PostGenerationRequest request) {
    if (request.bloguleDeclarations.isEmpty) {
      throw ArgumentError('At least one blogule declaration is required.');
    }

    final String declarationName =
        request.declarationName?.trim().isNotEmpty == true
            ? request.declarationName!.trim()
            : _IdentifierTools.declarationNameFromTitle(request.title);

    final StringBuffer buffer = StringBuffer()
      ..writeln('final LPPost $declarationName = LPPost(')
      ..writeln('  title: ${_literal(request.title)},')
      ..writeln('  description: ${_literal(request.description)},')
      ..writeln(
        '  publicationDate: ${_dateLiteral(request.publicationDate)},',
      )
      ..writeln('  lastUpdate: ${_dateLiteral(request.lastUpdate)},')
      ..writeln(
        '  blogules: [${request.bloguleDeclarations.join(', ')}],',
      );

    if (request.previewMode) {
      buffer.writeln('  isPreviewMode: true,');
    }

    buffer.writeln(');');
    return buffer.toString();
  }
}

class _ParsedMarkdown {
  final String title;
  final bool includeTableOfContents;
  final List<md.Node> nodes;

  const _ParsedMarkdown({
    required this.title,
    required this.includeTableOfContents,
    required this.nodes,
  });

  factory _ParsedMarkdown.parse(String source) {
    final List<String> lines = source.replaceAll('\r\n', '\n').split('\n');
    while (lines.isNotEmpty && lines.first.trim().isEmpty) {
      lines.removeAt(0);
    }

    String title = '';
    if (lines.isNotEmpty && !_looksLikeMarkdownBlock(lines.first.trim())) {
      title = lines.removeAt(0).trim();
    }

    bool includeTableOfContents = false;
    lines.removeWhere((String line) {
      if (line.trim() == '<TOC>') {
        includeTableOfContents = true;
        return true;
      }
      return false;
    });

    final List<md.Node> nodes = md.Document(
      extensionSet: md.ExtensionSet.gitHubFlavored,
      blockSyntaxes: <md.BlockSyntax>[
        _VerseQuoteBlockSyntax(),
        _ImageBlockSyntax(),
        _DividerBlockSyntax(),
        _SideNoteBlockSyntax(),
      ],
    ).parse(lines.join('\n'));

    return _ParsedMarkdown(
      title: title,
      includeTableOfContents: includeTableOfContents,
      nodes: nodes,
    );
  }

  static bool _looksLikeMarkdownBlock(String line) {
    return line.startsWith('#') ||
        line.startsWith('>') ||
        line.startsWith('- ') ||
        line.startsWith('* ') ||
        RegExp(r'^\d+[.)]\s').hasMatch(line) ||
        line.startsWith('```') ||
        line.startsWith('@') ||
        line.startsWith('<');
  }
}

class _ComponentEmitter {
  Map<String, String>? _pendingLeftSideNote;
  Map<String, String>? _pendingRightSideNote;

  List<String> emitAll(List<md.Node> nodes) {
    final List<String> results = <String>[];
    for (final md.Node node in nodes) {
      results.addAll(_emitNode(node));
    }
    return results;
  }

  List<String> _emitNode(md.Node node) {
    if (node is md.Text) {
      final String content = node.text.trim();
      if (content.isEmpty) {
        return const <String>[];
      }
      return <String>[
        'LPText.plainBody(content: ${_literal(content)}${_consumeNoteArgs()}),',
      ];
    }

    if (node is! md.Element) {
      return const <String>[];
    }

    switch (node.tag) {
      case 'note':
        if ((node.attributes['leftSide'] ?? 'false') == 'true') {
          _pendingLeftSideNote = node.attributes;
        } else {
          _pendingRightSideNote = node.attributes;
        }
        return const <String>[];
      case 'h1':
        return <String>[
          'LPText.header1(content: ${_literal(_flattenText(node))}${_consumeNoteArgs()}),',
        ];
      case 'h2':
        return <String>[
          'LPText.header2(content: ${_literal(_flattenText(node))}${_consumeNoteArgs()}),',
        ];
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        return <String>[
          'LPText.header3(content: ${_literal(_flattenText(node))}${_consumeNoteArgs()}),',
        ];
      case 'p':
        final String? paragraph =
            _emitParagraph(node.children ?? const <md.Node>[]);
        return paragraph == null ? const <String>[] : <String>[paragraph];
      case 'blockquote':
        return <String>[
          'LPPullQuote(content: ${_literal(_flattenText(node).trim())}${_consumeNoteArgs()}),',
        ];
      case 'ul':
        return <String>[_emitList(node, 'LPListType.bullet')];
      case 'ol':
        return <String>[_emitList(node, 'LPListType.numbered')];
      case 'pre':
        return <String>[_emitCodeBlock(node)];
      case 'img':
        final String? url = node.attributes['url'];
        if (url == null || url.trim().isEmpty) {
          return const <String>[];
        }
        final String width =
            _numericLiteral(node.attributes['width'], fallback: '800');
        final String height =
            _numericLiteral(node.attributes['height'], fallback: '450');
        return <String>[
          'LPImage.url(url: ${_literal(url)}, width: $width, height: $height${_consumeNoteArgs()}),',
        ];
      case 'versequote':
        return <String>[_emitVerseQuote(node)];
      case 'div':
      case 'hr':
        return <String>['LPDivider(),'];
      default:
        final List<String> emitted = <String>[];
        for (final md.Node child in node.children ?? const <md.Node>[]) {
          emitted.addAll(_emitNode(child));
        }
        return emitted;
    }
  }

  String? _emitParagraph(List<md.Node> children) {
    final List<_InlineFragment> fragments = _emitInline(children);
    if (fragments.isEmpty) {
      return null;
    }

    if (fragments.length == 1 &&
        fragments.first.variant == _InlineVariant.plain) {
      return 'LPText.plainBody(content: ${_literal(fragments.first.content)}${_consumeNoteArgs()}),';
    }

    final StringBuffer buffer = StringBuffer()
      ..writeln('LPTextSpan(')
      ..writeln(_indent('lpTextComponents: [', 1));

    for (final _InlineFragment fragment in fragments) {
      buffer.writeln(_indent('${fragment.expression},', 2));
    }

    buffer
      ..write(_indent(']${_consumeNoteArgs()}', 1))
      ..writeln(',')
      ..write('),');

    return buffer.toString();
  }

  String _emitList(md.Element node, String listType) {
    final List<String> itemExpressions = <String>[];
    for (final md.Node child in node.children ?? const <md.Node>[]) {
      if (child is! md.Element || child.tag != 'li') {
        continue;
      }

      final String? paragraph =
          _emitParagraph(child.children ?? const <md.Node>[]);
      if (paragraph != null) {
        itemExpressions.add(paragraph.substring(0, paragraph.length - 1));
        continue;
      }

      final List<String> nestedBlocks = <String>[];
      for (final md.Node nested in child.children ?? const <md.Node>[]) {
        nestedBlocks.addAll(_emitNode(nested));
      }
      if (nestedBlocks.isEmpty) {
        continue;
      }
      if (nestedBlocks.length == 1) {
        itemExpressions.add(nestedBlocks.first.replaceFirst(RegExp(r',$'), ''));
      } else {
        final StringBuffer group = StringBuffer()
          ..writeln('LPGroup.vertical(')
          ..writeln(_indent('postComponents: [', 1));
        for (final String nested in nestedBlocks) {
          group.writeln(_indent(nested, 2));
        }
        group
          ..writeln(_indent('],', 1))
          ..write(')');
        itemExpressions.add(group.toString());
      }
    }

    final StringBuffer buffer = StringBuffer()
      ..writeln('LPSingleLevelListSpan(')
      ..writeln(_indent('listType: $listType,', 1))
      ..writeln(_indent('listItems: [', 1));

    for (final String item in itemExpressions) {
      buffer.writeln(_indent('$item,', 2));
    }

    buffer
      ..writeln(_indent(']${_consumeNoteArgs()},', 1))
      ..write('),');

    return buffer.toString();
  }

  String _emitCodeBlock(md.Element node) {
    md.Element? codeNode;
    for (final md.Node child in node.children ?? const <md.Node>[]) {
      if (child is md.Element && child.tag == 'code') {
        codeNode = child;
        break;
      }
    }

    final String languageClass = codeNode?.attributes['class'] ?? '';
    final String language = languageClass.startsWith('language-')
        ? languageClass.substring('language-'.length)
        : 'plain';
    final String content = _flattenText(codeNode ?? node).trimRight();

    return 'LPCodeBlock(content: ${_literal(content)}, lang: ${_literal(language)}${_consumeNoteArgs()}),';
  }

  String _emitVerseQuote(md.Element node) {
    final List<String> verses = (node.attributes['verses'] ?? '')
        .split('|')
        .map((String verse) => verse.trim())
        .where((String verse) => verse.isNotEmpty)
        .toList();
    final String artist = (node.attributes['artist'] ?? '').trim();
    final String song = (node.attributes['song'] ?? '').trim();
    final String album = (node.attributes['album'] ?? '').trim();
    final String hyperlink = (node.attributes['hyperlink'] ?? '').trim();

    final List<String> referenceParts = <String>[
      if (artist.isNotEmpty) artist,
      if (song.isNotEmpty) song,
      if (album.isNotEmpty) '($album)',
    ];

    final StringBuffer buffer = StringBuffer()
      ..writeln('LPVerseQuote(')
      ..writeln(_indent('verses: ${_listLiteral(verses)},', 1))
      ..writeln(_indent(
          'reference: ${_literal(referenceParts.join(', ').replaceAll(', (', ' ('))},',
          1));

    if (hyperlink.isNotEmpty) {
      buffer.writeln(
          _indent('url: ${_literal(hyperlink)}${_consumeNoteArgs()},', 1));
    } else {
      final String noteArgs = _consumeNoteArgs();
      if (noteArgs.isNotEmpty) {
        buffer.writeln(_indent('${noteArgs.substring(2)},', 1));
      }
    }

    buffer.write('),');
    return buffer.toString();
  }

  List<_InlineFragment> _emitInline(List<md.Node> nodes) {
    final List<_InlineFragment> fragments = <_InlineFragment>[];

    for (final md.Node node in nodes) {
      if (node is md.Text) {
        if (node.text.isNotEmpty) {
          fragments.add(
            _InlineFragment(
              variant: _InlineVariant.plain,
              content: node.text,
              expression: 'LPText.plainBody(content: ${_literal(node.text)})',
            ),
          );
        }
        continue;
      }

      if (node is! md.Element) {
        continue;
      }

      switch (node.tag) {
        case 'a':
          fragments.add(
            _InlineFragment(
              variant: _InlineVariant.rich,
              content: _flattenText(node),
              expression:
                  'LPText.hyperlink(content: ${_literal(_flattenText(node))}, url: ${_literal(node.attributes['href'] ?? '')})',
            ),
          );
          break;
        case 'code':
          fragments.add(
            _InlineFragment(
              variant: _InlineVariant.rich,
              content: _flattenText(node),
              expression:
                  'LPText.codeStyle(content: ${_literal(_flattenText(node))}, inline: true)',
            ),
          );
          break;
        case 'em':
          fragments.add(
            _InlineFragment(
              variant: _InlineVariant.rich,
              content: _flattenText(node),
              expression:
                  'LPText.plainBody(content: ${_literal(_flattenText(node))}, isItalic: true)',
            ),
          );
          break;
        case 'strong':
          fragments.add(
            _InlineFragment(
              variant: _InlineVariant.rich,
              content: _flattenText(node),
              expression:
                  'LPText.plainBody(content: ${_literal(_flattenText(node))}, isBold: true)',
            ),
          );
          break;
        case 'del':
          fragments.add(
            _InlineFragment(
              variant: _InlineVariant.rich,
              content: _flattenText(node),
              expression:
                  'LPText.plainBody(content: ${_literal(_flattenText(node))}, isStrikethrough: true)',
            ),
          );
          break;
        case 'br':
          fragments.add(
            _InlineFragment(
              variant: _InlineVariant.rich,
              content: '\n',
              expression: 'LPText.paragraphBreak()',
            ),
          );
          break;
        default:
          fragments.addAll(_emitInline(node.children ?? const <md.Node>[]));
      }
    }

    return fragments;
  }

  String _consumeNoteArgs() {
    final List<String> args = <String>[];

    if (_pendingLeftSideNote != null) {
      final String text = _pendingLeftSideNote!['text'] ?? '';
      args.add(
        'leftSideNotes: const [LPSideNoteComment(text: ${_literal(text)}, leftSide: true)]',
      );
      _pendingLeftSideNote = null;
    }

    if (_pendingRightSideNote != null) {
      final String text = _pendingRightSideNote!['text'] ?? '';
      args.add(
        'rightSideNotes: const [LPSideNoteComment(text: ${_literal(text)}, leftSide: false)]',
      );
      _pendingRightSideNote = null;
    }

    if (args.isEmpty) {
      return '';
    }
    return ', ${args.join(', ')}';
  }
}

enum _InlineVariant { plain, rich }

class _InlineFragment {
  final _InlineVariant variant;
  final String content;
  final String expression;

  const _InlineFragment({
    required this.variant,
    required this.content,
    required this.expression,
  });
}

class _IdentifierTools {
  static String declarationNameFromTitle(String title) {
    final List<String> tokens = _tokens(title);
    if (tokens.isEmpty) {
      return 'generated_article';
    }
    final String joined = tokens.join('_').toLowerCase();
    return RegExp(r'^[0-9]').hasMatch(joined) ? 'article_$joined' : joined;
  }

  static String moduleClassNameFromTitle(String title) {
    final List<String> tokens = _tokens(title);
    if (tokens.isEmpty) {
      return 'Generated_Article';
    }
    final String joined = tokens
        .map((String token) => '${token[0].toUpperCase()}${token.substring(1)}')
        .join('_');
    return RegExp(r'^[0-9]').hasMatch(joined) ? 'Article_$joined' : joined;
  }

  static List<String> _tokens(String value) {
    return value
        .replaceAll('&', ' and ')
        .split(RegExp(r'[^A-Za-z0-9]+'))
        .where((String token) => token.isNotEmpty)
        .toList();
  }
}

class _StructuredBlockSyntax extends md.BlockSyntax {
  final RegExp _pattern;
  final String _tag;

  _StructuredBlockSyntax(this._tag, String tagPattern)
      : _pattern = RegExp('^$tagPattern \\{');

  @override
  RegExp get pattern => _pattern;

  @override
  bool canParse(md.BlockParser parser) =>
      pattern.hasMatch(parser.current.content);

  @override
  md.Node? parse(md.BlockParser parser) {
    final Map<String, String> attrs = <String, String>{};
    parser.advance();

    while (!parser.isDone && parser.current.content.trim() != '}') {
      final String line = parser.current.content.trim();
      if (line.isEmpty) {
        parser.advance();
        continue;
      }

      final _ParsedKeyValue pair = _parseKeyValue(line);
      if (pair.key != 'verses') {
        attrs[pair.key] = pair.value;
        parser.advance();
        continue;
      }

      final List<String> verses = <String>[];
      parser.advance();
      while (!parser.isDone && parser.current.content.trim() != ']') {
        final String verse = parser.current.content.trim();
        if (verse.isNotEmpty) {
          verses.add(verse);
        }
        parser.advance();
      }
      attrs['verses'] = verses.join('|');
      if (!parser.isDone) {
        parser.advance();
      }
    }

    if (!parser.isDone && parser.current.content.trim() == '}') {
      parser.advance();
    }

    return md.Element.text(_tag, '')..attributes.addAll(attrs);
  }

  @override
  List<md.Line?> parseChildLines(md.BlockParser parser) => const <md.Line?>[];

  @override
  bool canEndBlock(md.BlockParser parser) => true;

  @override
  md.BlockSyntax? interruptedBy(md.BlockParser parser) => null;
}

class _ImageBlockSyntax extends _StructuredBlockSyntax {
  _ImageBlockSyntax() : super('img', '@img');
}

class _VerseQuoteBlockSyntax extends _StructuredBlockSyntax {
  _VerseQuoteBlockSyntax() : super('versequote', '@versequote');
}

class _SideNoteBlockSyntax extends _StructuredBlockSyntax {
  _SideNoteBlockSyntax() : super('note', '@note');
}

class _DividerBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^@div$');

  @override
  bool canParse(md.BlockParser parser) =>
      pattern.hasMatch(parser.current.content.trim());

  @override
  md.Node? parse(md.BlockParser parser) {
    parser.advance();
    return md.Element.text('div', '');
  }

  @override
  List<md.Line?> parseChildLines(md.BlockParser parser) => const <md.Line?>[];

  @override
  bool canEndBlock(md.BlockParser parser) => true;

  @override
  md.BlockSyntax? interruptedBy(md.BlockParser parser) => null;
}

class _ParsedKeyValue {
  final String key;
  final String value;

  const _ParsedKeyValue(this.key, this.value);
}

_ParsedKeyValue _parseKeyValue(String line) {
  if (line.contains('>>')) {
    final List<String> chunks = line.split('>>');
    return _ParsedKeyValue(
      chunks.first.trim(),
      chunks.sublist(1).join('>>').trim(),
    );
  }

  final List<String> chunks = line.split(':');
  return _ParsedKeyValue(
    chunks.first.trim(),
    chunks.sublist(1).join(':').trim(),
  );
}

String _flattenText(md.Node node) {
  if (node is md.Text) {
    return _decodeEntities(node.text);
  }
  if (node is! md.Element) {
    return '';
  }

  return (node.children ?? const <md.Node>[]).map<String>(_flattenText).join();
}

String _decodeEntities(String value) {
  return value
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&amp;', '&');
}

String _literal(String value) => jsonEncode(value);

String _listLiteral(List<String> values) =>
    '[${values.map(_literal).join(', ')}]';

String _dateLiteral(DateTime value) =>
    'DateTime(${value.year}, ${value.month}, ${value.day})';

String _numericLiteral(String? raw, {required String fallback}) {
  if (raw == null) {
    return fallback;
  }
  final String trimmed = raw.trim();
  if (trimmed.isEmpty) {
    return fallback;
  }
  return num.tryParse(trimmed)?.toString() ?? fallback;
}

String _indent(String value, int level) {
  final String prefix = '  ' * level;
  return value
      .split('\n')
      .map((String line) => line.isEmpty ? line : '$prefix$line')
      .join('\n');
}
