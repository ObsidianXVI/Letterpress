part of markdown_parser;

class ParserConfigs {
  final List<ParserComponent> lineTriggeredParsers;
  final List<ParserComponent> charTriggeredParsers;

  ParserConfigs({
    required this.lineTriggeredParsers,
    required this.charTriggeredParsers,
    required bool includeCoreTokens,
  }) {
    if (includeCoreTokens) {
      lineTriggeredParsers.addAll([
        const Header6_Parser(),
        const Header5_Parser(),
        const Header4_Parser(),
        const Header3_Parser(),
        const Header2_Parser(),
        const Header1_Parser(),
        const PullQuote_Parser(),
        const BlockCode_Parser(),
      ]);
      charTriggeredParsers.addAll([
        const InlineCode_Parser(),
        const ItalicText_Parser(),
        const BoldText_Parser(),
        const PlainText_Parser(),
      ]);
    }
  }
}
