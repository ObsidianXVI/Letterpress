part of markdown_parser;

abstract class ParserComponent_Old<T extends Token> {
  const ParserComponent_Old();

  T parse(String line, int lineNo);
  bool trigger(String line);
}

abstract class ParserComponent<T extends Token> {
  const ParserComponent();

  CursorLocation parse(SourceMap sourceMap, void Function(Token) addToken);

  bool trigger(String source);
}

class Header1_Parser extends ParserComponent<Header1> {
  const Header1_Parser();
  @override
  bool trigger(String source) => source.startsWith('# ');

  @override
  CursorLocation parse(SourceMap sourceMap, void Function(Token) addToken) {
    
    // TODO: implement parse
    throw UnimplementedError();
  }

/*   @override
  Header1 parse(SourceMap sourceMap, ) {
    return Header1(
      content: line.substring(2),
      lineNo: lineNo,
    );
  } */
}

class Header2_Parser extends ParserComponent<Header2> {
  const Header2_Parser();
  @override
  bool trigger(String source) => source.startsWith('## ');
  @override
  Header2 parse(String line, int lineNo) {
    return Header2(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}

class Header3_Parser extends ParserComponent<Header3> {
  const Header3_Parser();
  @override
  bool trigger(String line) => line.startsWith('### ');
  @override
  Header3 parse(String line, int lineNo) {
    return Header3(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}

class Header4_Parser extends ParserComponent<Header4> {
  const Header4_Parser();
  @override
  bool trigger(String line) => line.startsWith('#### ');
  @override
  Header4 parse(String line, int lineNo) {
    return Header4(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}

class Header5_Parser extends ParserComponent<Header5> {
  const Header5_Parser();
  @override
  bool trigger(String line) => line.startsWith('##### ');
  @override
  Header5 parse(String line, int lineNo) {
    return Header5(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}

class Header6_Parser extends ParserComponent<Header6> {
  const Header6_Parser();
  @override
  bool trigger(String line) => line.startsWith('###### ');
  @override
  Header6 parse(String line, int lineNo) {
    return Header6(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}

class PullQuote_Parser extends ParserComponent<PullQuote> {
  const PullQuote_Parser();

  @override
  bool trigger(String line) => line.startsWith('> ');

  @override
  PullQuote parse(String source, int lineNo) {
    final List<String> chars = source.split('');
    int quoteEnd = 3;
    bool prevWasNewline = false;
    for (int i = 0; i < chars.length; i++) {
      final String char = chars[i];
      if (char == '\n') {
        if (prevWasNewline) {
          quoteEnd = i;
          break;
        } else {
          prevWasNewline = true;
        }
      } else {
        prevWasNewline = false;
      }
    }
    final String quoteContent = source.substring(2, quoteEnd);
    String refContent = '';
    bool inRef = false;
    for (int i = quoteEnd; i < chars.length; i++) {
      final String char = chars[i];
      if (!inRef) {
        if (char == '—') {
          inRef = true;
        } else {
          refContent = refContent + char;
        }
      }
    }

    return PullQuote(
      content: quoteContent + refContent,
      lineNo: lineNo,
      quoteContent: quoteContent,
      reference: refContent,
    );
  }
}

class VerseQuote_Parser extends ParserComponent<VerseQuote> {
  const VerseQuote_Parser();

  @override
  bool trigger(String line) => line.startsWith('@verse');

  @override
  VerseQuote parse(String line, int lineNo) {
    // TODO: implement parse
    throw UnimplementedError();
  }
}

class BlockCode_Parser extends ParserComponent<BlockCode> {
  const BlockCode_Parser();

  @override
  bool trigger(String line) => line.startsWith('```');

  @override
  BlockCode parse(String line, int lineNo) {
    final List<String> lines = line.split('\n');
    final String lang = lines.first.trim().replaceAll('```', '');
    int endIndex = lines.length - 1;
    for (int i = 1; i < lines.length; i++) {
      if (lines[i].trim() == '```') {
        endIndex = i - 1;
        break;
      }
    }

    return BlockCode(
      content: lines.sublist(0, endIndex + 1).join('\n'),
      lineNo: lineNo,
      codeContent: lines.sublist(1, endIndex).join('\n'),
      language: lang,
    );
  }
}

class Callout_Parser extends ParserComponent<Callout> {
  const Callout_Parser();

  @override
  bool trigger(String line) => line.startsWith('@callout');

  @override
  Callout parse(String line, int lineNo) {
    // TODO: implement parse
    throw UnimplementedError();
  }
}

class PlainText_Parser extends ParserComponent<PlainText> {
  const PlainText_Parser();

  @override
  bool trigger(String line) => true;

  @override
  PlainText parse(String line, int lineNo) {
    return PlainText(content: line, lineNo: lineNo);
  }
}

class InlineCode_Parser extends ParserComponent<InlineCode> {
  const InlineCode_Parser();

  @override
  bool trigger(String line) => line == '`';

  @override
  InlineCode parse(String line, int lineNo) {
    // TODO: implement parse
    throw UnimplementedError();
  }
}

class BoldText_Parser extends ParserComponent<BoldText> {
  const BoldText_Parser();

  @override
  bool trigger(String line) => line == '*';
  @override
  BoldText parse(String line, int lineNo) {
    // TODO: implement parse
    throw UnimplementedError();
  }
}

class ItalicText_Parser extends ParserComponent<ItalicText> {
  const ItalicText_Parser();

  @override
  bool trigger(String line) => line == '*';

  @override
  ItalicText parse(String line, int lineNo) {
    // TODO: implement parse
    throw UnimplementedError();
  }
}
