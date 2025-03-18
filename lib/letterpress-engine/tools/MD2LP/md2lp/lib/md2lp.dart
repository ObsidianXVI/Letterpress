library letterpress.tools.md2lp;

import 'package:markdown/markdown.dart';

enum ParseMode { textspan, orderedList, unorderedList }

class VerseQuoteParser implements BlockSyntax {
  VerseQuoteParser();

  @override
  RegExp get pattern => RegExp(r'^@versequote \{');

  @override
  bool canParse(BlockParser parser) => pattern.hasMatch(parser.current.content);

  @override
  Node? parse(BlockParser parser) {
    final List<String> lines = [];
    final Map<String, String> attrs = {};

    while ((parser..advance()).current.content.trim() != '}') {
      lines.add(parser.current.content);
      final List<String> chunks = parser.current.content.split('>>');
      final String param = chunks[0].trim();
      final String val = chunks[1].trim();
      if (param != 'verses') {
        attrs[param] = val;
      } else {
        final List<String> verses = [];
        while ((parser..advance()).current.content.trim() != ']') {
          parser.advance();
          lines.add(parser.current.content);
          verses.add(parser.current.content.trim());
        }
        attrs['verses'] = verses.join('|');
      }
    }

    return Element.text('versequote', lines.join('\n'))
      ..attributes.addAll(attrs);
  }

  @override
  List<Line?> parseChildLines(BlockParser parser) {
    return const [];
  }

  @override
  bool canEndBlock(BlockParser parser) {
    // TODO: implement canEndBlock
    throw UnimplementedError();
  }

  @override
  BlockSyntax? interruptedBy(BlockParser parser) {
    // TODO: implement interruptedBy
    throw UnimplementedError();
  }
}

class ImageBlockParser implements BlockSyntax {
  ImageBlockParser();

  @override
  RegExp get pattern => RegExp(r'^@img \{');

  @override
  bool canParse(BlockParser parser) => pattern.hasMatch(parser.current.content);

  @override
  Node? parse(BlockParser parser) {
    final List<String> lines = [];
    final Map<String, String> attrs = {};

    while ((parser..advance()).current.content.trim() != '}') {
      lines.add(parser.current.content);
      final List<String> chunks = parser.current.content.split('>>');
      attrs[chunks[0].trim()] = chunks[1].trim();
    }

    return Element.text('img', lines.join('\n'))..attributes.addAll(attrs);
  }

  @override
  List<Line?> parseChildLines(BlockParser parser) {
    return const [];
  }

  @override
  bool canEndBlock(BlockParser parser) => true;

  @override
  BlockSyntax? interruptedBy(BlockParser parser) {
    // TODO: implement interruptedBy
    throw UnimplementedError();
  }
}

class SideNoteBlockParser implements BlockSyntax {
  SideNoteBlockParser();

  @override
  RegExp get pattern => RegExp(r'^@note \{');

  @override
  bool canParse(BlockParser parser) => pattern.hasMatch(parser.current.content);

  @override
  Node? parse(BlockParser parser) {
    final List<String> lines = [];
    final Map<String, String> attrs = {};

    while ((parser..advance()).current.content.trim() != '}') {
      lines.add(parser.current.content);
      final List<String> chunks = parser.current.content.split('>>');
      attrs[chunks[0].trim()] = chunks[1].trim();
    }

    return Element.text('note', lines.join('\n'))..attributes.addAll(attrs);
  }

  @override
  List<Line?> parseChildLines(BlockParser parser) {
    return const [];
  }

  @override
  bool canEndBlock(BlockParser parser) => true;

  @override
  BlockSyntax? interruptedBy(BlockParser parser) {
    // TODO: implement interruptedBy
    throw UnimplementedError();
  }
}

class MD2LP_Transpiler {
  final List<ParseMode> parseModes = [];
  final List<String> result = [];
  Map<String, String>? leftSideNote;
  Map<String, String>? rightSideNote;

  String transpile(String mdSource) {
    final ast = Document(
      extensionSet: ExtensionSet.gitHubFlavored,
      blockSyntaxes: [
        VerseQuoteParser(),
        ImageBlockParser(),
        SideNoteBlockParser()
      ],
    ).parse(mdSource);
    for (final Node node in ast) {
      handleNode(node);
    }
    return result.join('\n');
  }

  void handleNode(Node n) {
    if (n is Element) {
      return handleElementNode(n);
    } else {
      n as Text;
      return handleTextNode(n);
    }
  }

  void handleElementNode(Element e) {
    print(
        "[${e.tag}] ${e.children != null ? '(${e.children!.length})' : ''} ${e.textContent}");

    if (e.children == null) result.add(e.textContent);
    if (e.children!.length > 1) {
      switch (e.tag) {
        case 'p':
          parseModes.add(ParseMode.textspan);
          result.add("LPTextSpan(lpTextComponents: [");
          break;
        case 'ul':
          parseModes.add(ParseMode.unorderedList);
          result.add(
              "LPSingleLevelListSpan(listType: LPListType.bullet, listItems: [");
          break;
        case 'ol':
          parseModes.add(ParseMode.orderedList);
          result.add(
              "LPSingleLevelListSpan(listType:  LPListType.numbered, listItems: [");
          break;
        case 'li':
          parseModes.add(ParseMode.textspan);
          result.add("LPTextSpan(lpTextComponents: [");
          break;
      }

      for (final Node n in e.children!) {
        handleNode(n);
      }
      if (parseModes.isNotEmpty) {
        switch (parseModes.last) {
          case ParseMode.textspan:
          case ParseMode.unorderedList:
          case ParseMode.orderedList:
            result.add("],),");
            parseModes.removeLast();
          default:
            break;
        }
      }
    } else {
      // Single-child element means child is a Text node
      switch (e.tag) {
        case 'h1':
          result.add(
              "LPText.header1(content: \"${e.textContent.sanitised()}\",${injectSideNotesIfPresent()}),");
          break;
        case 'h2':
          result.add(
              "LPText.header2(content: \"${e.textContent.sanitised()}\",${injectSideNotesIfPresent()}),");
          break;
        case 'h3':
          result.add(
              "LPText.header3(content: \"${e.textContent.sanitised()}\",${injectSideNotesIfPresent()}),");
          break;
        case 'a':
          result.add(
              "LPText.hyperlink(content: \"${e.textContent.sanitised()}\", url: \"${e.attributes['href']}\",${injectSideNotesIfPresent()}),");
          break;
        case 'em':
          result.add(
              "LPText.plainBody(content: \"${e.textContent.sanitised()}\", isBold: true,${injectSideNotesIfPresent()}),");
          break;
        case 'strong':
          result.add(
              "LPText.plainBody(content: \"${e.textContent.sanitised()}\", isItalic: true,${injectSideNotesIfPresent()}),");
          break;
        case 'del':
          result.add(
              "LPText.plainBody(content: \"${e.textContent.sanitised()}\", isStrikethrough: true,${injectSideNotesIfPresent()}),");
          break;
        case 'pre':
          break;
        case 'code':
          result.add(
              "LPText.codeStyle(content: \"${e.textContent.sanitised()}\", inline: ${parseModes.isNotEmpty},${injectSideNotesIfPresent()}),");
          break;
        case 'versequote':
          result.add(
              "LPVerseQuote(verses: ${e.attributes['verses']!.split('|').map((x) => '"$x"').toList()}, reference: \"${e.attributes['artist']}\" + ', ' + \"${e.attributes['song']}\" + ' (' + \"${e.attributes['album']}\" + ')', url: \"${e.attributes['hyperlink']}\"),");
          break;
        case 'img':
          result.add(
              "LPImage.url(url: \"${e.attributes['url']}\", width: ${e.attributes['width']}, height: ${e.attributes['height']},${injectSideNotesIfPresent()}),");
          break;
        // The note must appear BEFORE the block to which it is going to be attached
        case 'note':
          if (e.attributes['leftSide'] == 'true') {
            leftSideNote = e.attributes;
          } else {
            rightSideNote = e.attributes;
          }
          break;
        case 'li':
          result.add(
              "LPText.plainBody(content: \"${e.textContent.sanitised()}\",${injectSideNotesIfPresent()}),");
          break;
        default:
          break;
      }
    }
  }

  void handleTextNode(Text t) {
    result.add(
        "LPText.plainBody(content: \"${t.textContent.sanitised()}\",${injectSideNotesIfPresent()}),");
  }

  String injectSideNotesIfPresent() {
    String res = '';
    if (leftSideNote != null) {
      res +=
          'leftSideNotes: [LPSideNoteComment(text: "${leftSideNote!['text']}", leftSide: true,),],';
      leftSideNote = null;
    }
    if (rightSideNote != null) {
      res +=
          'leftSideNotes: [LPSideNoteComment(text: "${rightSideNote!['text']}", leftSide: false,),],';
      rightSideNote = null;
    }

    return res;
  }
}

extension StringUtils on String {
  String sanitised() => replaceAll('\n', '\\n').replaceAll('&quot;', '"');
}
