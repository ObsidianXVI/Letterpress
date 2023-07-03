part of markdown_parser;

abstract class Token {
  final String content;
  final int lineNo;

  const Token({
    required this.content,
    required this.lineNo,
  });
}

class Header1 extends Token {
  const Header1({
    required super.content,
    required super.lineNo,
  });
}

class Header2 extends Token {
  const Header2({
    required super.content,
    required super.lineNo,
  });
}

class Header3 extends Token {
  const Header3({
    required super.content,
    required super.lineNo,
  });
}

class Header4 extends Token {
  const Header4({
    required super.content,
    required super.lineNo,
  });
}

class Header5 extends Token {
  const Header5({
    required super.content,
    required super.lineNo,
  });
}

class Header6 extends Token {
  const Header6({
    required super.content,
    required super.lineNo,
  });
}

class PullQuote extends Token {
  final String quoteContent;
  final String reference;
  final List<String> chars;
  int quoteEnd = 3;

  PullQuote({
    required super.content,
    required super.lineNo,
    required this.quoteContent,
    required this.reference,
  }) : chars = content.split('');

  static PullQuote parse(String source, int lineNo) {
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

class VerseQuote extends Token {
  final String verses;
  final String artist;
  final String song;
  final String album;

  const VerseQuote({
    required super.content,
    required super.lineNo,
    required this.verses,
    required this.album,
    required this.artist,
    required this.song,
  });
}

class BlockCode extends Token {
  final String language;

  const BlockCode({
    required super.content,
    required super.lineNo,
    required this.language,
  });
}

class InlineCode extends Token {
  const InlineCode({
    required super.content,
    required super.lineNo,
  });
}

class Callout extends Token {
  const Callout({
    required super.content,
    required super.lineNo,
  });
}

class PlainText extends Token {
  const PlainText({
    required super.content,
    required super.lineNo,
  });
}

class BoldText extends Token {
  const BoldText({
    required super.content,
    required super.lineNo,
  });
}

class ItalicText extends Token {
  const ItalicText({
    required super.content,
    required super.lineNo,
  });
}
