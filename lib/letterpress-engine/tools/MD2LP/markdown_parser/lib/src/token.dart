part of markdown_parser;

abstract class Token {
  final String content;
  final int lineNo;

  const Token({
    required this.content,
    required this.lineNo,
  });
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
