part of markdown_parser;

abstract class Token {
  final String content;
  final CursorLocation cursorLocation;

  const Token({
    required this.content,
    required this.cursorLocation,
  });
}

class StructuredToken extends Token {
  final String identifier;
  final Map<String, dynamic> params;
  const StructuredToken({
    required this.identifier,
    required this.params,
    required super.content,
    required super.cursorLocation,
  });
}

class Header1 extends Token {
  const Header1({
    required super.content,
    required super.cursorLocation,
  });
}

class Header2 extends Token {
  const Header2({
    required super.content,
    required super.cursorLocation,
  });
}

class Header3 extends Token {
  const Header3({
    required super.content,
    required super.cursorLocation,
  });
}

class Header4 extends Token {
  const Header4({
    required super.content,
    required super.cursorLocation,
  });
}

class Header5 extends Token {
  const Header5({
    required super.content,
    required super.cursorLocation,
  });
}

class Header6 extends Token {
  const Header6({
    required super.content,
    required super.cursorLocation,
  });
}

class PullQuote extends Token {
  final String quoteContent;
  final String reference;

  const PullQuote({
    required super.content,
    required super.cursorLocation,
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
    required super.cursorLocation,
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
    required super.cursorLocation,
  });
}

class InlineCode extends Token {
  const InlineCode({
    required super.content,
    required super.cursorLocation,
  });
}

class Callout extends Token {
  const Callout({
    required super.content,
    required super.cursorLocation,
  });
}

class PlainText extends Token {
  const PlainText({
    required super.content,
    required super.cursorLocation,
  });
}

class BoldText extends Token {
  const BoldText({
    required super.content,
    required super.cursorLocation,
  });
}

class ItalicText extends Token {
  const ItalicText({
    required super.content,
    required super.cursorLocation,
  });
}
