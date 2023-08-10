part of markdown_parser;

abstract class ParserComponent<T extends Token> {
  const ParserComponent();

  T parse(SourceMap sourceMap);

  bool trigger(String source);
}

class Header1_Parser extends ParserComponent<Header1> {
  const Header1_Parser();
  @override
  bool trigger(String source) => source.startsWith('# ');

  @override
  Header1 parse(SourceMap sourceMap) {
    sourceMap.consumeChar(2);
    return Header1(
      content: sourceMap.consumeUntil('\n').join(),
      cursorLocation: sourceMap.currentLocation,
    );
  }
}

class Header2_Parser extends ParserComponent<Header2> {
  const Header2_Parser();
  @override
  bool trigger(String source) => source.startsWith('## ');

  @override
  Header2 parse(SourceMap sourceMap) {
    sourceMap.consumeChar(3);
    return Header2(
      content: sourceMap.consumeUntil('\n').join(),
      cursorLocation: sourceMap.currentLocation,
    );
  }
}

class Header3_Parser extends ParserComponent<Header3> {
  const Header3_Parser();
  @override
  bool trigger(String line) => line.startsWith('### ');

  @override
  Header3 parse(SourceMap sourceMap) {
    sourceMap.consumeChar(4);
    return Header3(
      content: sourceMap.consumeUntil('\n').join(),
      cursorLocation: sourceMap.currentLocation,
    );
  }
}

class Header4_Parser extends ParserComponent<Header4> {
  const Header4_Parser();
  @override
  bool trigger(String line) => line.startsWith('#### ');

  @override
  Header4 parse(SourceMap sourceMap) {
    sourceMap.consumeChar(5);
    return Header4(
      content: sourceMap.consumeUntil('\n').join(),
      cursorLocation: sourceMap.currentLocation,
    );
  }
}

class Header5_Parser extends ParserComponent<Header5> {
  const Header5_Parser();
  @override
  bool trigger(String line) => line.startsWith('##### ');
  @override
  Header5 parse(SourceMap sourceMap) {
    sourceMap.consumeChar(6);
    return Header5(
      content: sourceMap.consumeUntil('\n').join(),
      cursorLocation: sourceMap.currentLocation,
    );
  }
}

class Header6_Parser extends ParserComponent<Header6> {
  const Header6_Parser();
  @override
  bool trigger(String line) => line.startsWith('###### ');

  @override
  Header6 parse(SourceMap sourceMap) {
    sourceMap.consumeChar(7);
    return Header6(
      content: sourceMap.consumeUntil('\n').join(),
      cursorLocation: sourceMap.currentLocation,
    );
  }
}

class PullQuote_Parser extends ParserComponent<PullQuote> {
  const PullQuote_Parser();

  @override
  bool trigger(String line) => line.startsWith('> ');

  @override
  PullQuote parse(SourceMap sourceMap) {
    sourceMap.consumeChar(2);
    final List<String> contentChars = [];
    final List<String> refChars = [];

    void innerParse() {
      contentChars.addAll(sourceMap.consumeUntil('\n'));
      if (sourceMap.peekChar() == '—') {
        sourceMap.consumeChar();
        contentChars.removeLast();
        refChars.addAll(sourceMap.consumeUntil('\n'));
      } else {
        contentChars.clear();
        innerParse();
      }
    }

    innerParse();

    return PullQuote(
      content: "${contentChars.join()}\n${refChars.join()}",
      quoteContent: contentChars.join(),
      reference: refChars.join(),
      cursorLocation: sourceMap.currentLocation,
    );
  }
}

class VerseQuote_Parser extends ParserComponent<VerseQuote>
    with StructuredParsing {
  const VerseQuote_Parser();

  @override
  bool trigger(String source) {
    if (source.startsWith('@versequote')) print('trigger');
    return source.startsWith('@versequote');
  }

  @override
  VerseQuote parse(SourceMap sourceMap) {
    final StructuredToken tok = parseStructured(sourceMap);
    return VerseQuote(
      content: tok.content,
      cursorLocation: tok.cursorLocation,
      verses: tok.params['verses'],
      album: tok.params['album'],
      artist: tok.params['artist'],
      song: tok.params['song'],
    );
  }
}

class BlockCode_Parser extends ParserComponent<BlockCode> {
  const BlockCode_Parser();

  @override
  bool trigger(String source) => source.startsWith('```');

  @override
  BlockCode parse(SourceMap sourceMap) {
    sourceMap.consumeChar(3);
    final String lang = sourceMap.consumeUntil('\n').join();
    final String codeContent = sourceMap.consumeUntil('`').join();
    sourceMap.consumeChar(3);

    return BlockCode(
      content: lang + codeContent,
      codeContent: codeContent,
      language: lang,
      cursorLocation: sourceMap.currentLocation,
    );
  }
}

class Callout_Parser extends ParserComponent<Callout> {
  const Callout_Parser();

  @override
  bool trigger(String line) => line.startsWith('@callout');

  @override
  Callout parse(SourceMap sourceMap) {
    // TODO: implement parse
    throw UnimplementedError();
  }
}

class PlainText_Parser extends ParserComponent<PlainText> {
  const PlainText_Parser();

  @override
  bool trigger(String line) => true;

  @override
  PlainText parse(SourceMap sourceMap) {
    return PlainText(
      content: sourceMap.consumeChar(),
      cursorLocation: sourceMap.currentLocation,
    );
  }
}

class InlineCode_Parser extends ParserComponent<InlineCode> {
  const InlineCode_Parser();

  @override
  bool trigger(String line) => line == '`';

  @override
  InlineCode parse(SourceMap sourceMap) {
    // TODO: implement parse
    throw UnimplementedError();
  }
}

class BoldText_Parser extends ParserComponent<BoldText> {
  const BoldText_Parser();

  @override
  bool trigger(String line) => line == '*';
  @override
  BoldText parse(SourceMap sourceMap) {
    // TODO: implement parse
    throw UnimplementedError();
  }
}

class ItalicText_Parser extends ParserComponent<ItalicText> {
  const ItalicText_Parser();

  @override
  bool trigger(String line) => line == '*';

  @override
  ItalicText parse(SourceMap sourceMap) {
    // TODO: implement parse
    throw UnimplementedError();
  }
}
