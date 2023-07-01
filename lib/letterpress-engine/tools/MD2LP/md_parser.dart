library letterpress.tools.md2lp;

class CursorPosition {
  int colNo;
  int lineNo;

  CursorPosition({
    required this.colNo,
    required this.lineNo,
  });
}

class Cursor {
  int index = 0;
  final List<String> chars;
  final CursorPosition cursorPosition;

  Cursor({
    required this.chars,
    required this.cursorPosition,
  });

  String advance() {
    if (index++ == chars.length) {
      cursorPosition.colNo += 1;
      throw ParseToken.eof(cursorPosition: cursorPosition);
    } else {
      index += 1;
      if (chars[index] == '\n') {
        cursorPosition.colNo = 0;
        cursorPosition.lineNo += 1;
        return '\n';
      } else {
        cursorPosition.colNo += 1;
        return chars[index];
      }
    }
  }

  String? peek([int lookAhead = 0]) {
    if (index++ == chars.length) {
      return null;
    } else {
      final int newIndex = index + 1 + lookAhead;
      return chars[newIndex];
    }
  }
}

class MarkdownParser {
  final String src;
  final List<ParseToken> parseTokens = [];
  final Cursor cursor;

  MarkdownParser({
    required this.src,
  }) : cursor = Cursor(
          chars: src.split(''),
          cursorPosition: CursorPosition(colNo: 0, lineNo: 0),
        );

  void parse() {
    try {
      while (true) {
        if (cursor.advance() == '#') {}
      }
    } on ParseToken catch (e) {
      if (e.tokenType == TokenType.eof) {}
    }
  }
}

enum TokenType {
  header1,
  header2,
  header3,
  header4,
  header5,
  header6,

  blockCode,
  inlineCode,
  plainText,
  boldText,
  italicText,
  verseQuote,
  pullQuote,
  standardQuote,

  eof,
}

class ParseToken {
  final String lexeme;
  final TokenType tokenType;
  final String literal;
  final CursorPosition cursorPosition;

  const ParseToken({
    required this.lexeme,
    required this.tokenType,
    required this.literal,
    required this.cursorPosition,
  });

  const ParseToken.eof({
    required this.cursorPosition,
  })  : lexeme = '',
        tokenType = TokenType.eof,
        literal = '';
}
