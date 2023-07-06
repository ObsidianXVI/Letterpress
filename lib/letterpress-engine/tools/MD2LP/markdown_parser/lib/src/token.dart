part of markdown_parser;

abstract class Token {
  final String content;
  final int lineNo;

  const Token({
    required this.content,
    required this.lineNo,
  });
}

abstract class StandaloneToken extends Token {
  const StandaloneToken({
    required super.content,
    required super.lineNo,
  });

  bool trigger(String line);
}

abstract class IntraLineToken extends Token {
  const IntraLineToken({
    required super.content,
    required super.lineNo,
  });

  bool trigger(String char);
}

abstract class StructuredToken extends Token {
  final String identifier;
  final Map<String, Type> params;
  const StructuredToken({
    required this.identifier,
    required this.params,
    required super.content,
    required super.lineNo,
  });
}

class Header1 extends StandaloneToken {
  const Header1({
    required super.content,
    required super.lineNo,
  });

  @override
  bool trigger(String line) => line.startsWith('# ');
}

class Header2 extends StandaloneToken {
  const Header2({
    required super.content,
    required super.lineNo,
  });

  @override
  bool trigger(String line) => line.startsWith('## ');
}

class Header3 extends StandaloneToken {
  const Header3({
    required super.content,
    required super.lineNo,
  });

  @override
  bool trigger(String line) => line.startsWith('### ');
}

class Header4 extends StandaloneToken {
  const Header4({
    required super.content,
    required super.lineNo,
  });

  @override
  bool trigger(String line) => line.startsWith('#### ');
}

class Header5 extends StandaloneToken {
  const Header5({
    required super.content,
    required super.lineNo,
  });

  @override
  bool trigger(String line) => line.startsWith('##### ');
}

class Header6 extends StandaloneToken {
  const Header6({
    required super.content,
    required super.lineNo,
  });

  @override
  bool trigger(String line) => line.startsWith('###### ');
}

class PullQuote extends StandaloneToken {
  final String quoteContent;
  final String reference;

  const PullQuote({
    required super.content,
    required super.lineNo,
    required this.quoteContent,
    required this.reference,
  });

  @override
  bool trigger(String line) => line.startsWith('> ');

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

class VerseQuote extends StandaloneToken {
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

class BlockCode extends StandaloneToken {
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

class InlineCode extends IntraLineToken {
  const InlineCode({
    required super.content,
    required super.lineNo,
  });
}

class Callout extends StandaloneToken {
  const Callout({
    required super.content,
    required super.lineNo,
  });
}

class PlainText extends IntraLineToken {
  const PlainText({
    required super.content,
    required super.lineNo,
  });
}

class BoldText extends IntraLineToken {
  const BoldText({
    required super.content,
    required super.lineNo,
  });
}

class ItalicText extends IntraLineToken {
  const ItalicText({
    required super.content,
    required super.lineNo,
  });
}
