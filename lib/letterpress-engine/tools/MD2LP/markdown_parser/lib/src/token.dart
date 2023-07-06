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

  const PullQuote({
    required super.content,
    required super.lineNo,
    required this.quoteContent,
    required this.reference,
  });

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
  final String codeContent;

  const BlockCode({
    required this.language,
    required this.codeContent,
    required super.content,
    required super.lineNo,
  });

  static BlockCode parse(String source, int lineNo) {
    final List<String> lines = source.split('\n');
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

