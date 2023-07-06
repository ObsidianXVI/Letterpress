part of markdown_parser;

class ParserConfigs {
  final List<ParserComponent> standaloneComponents;
  final List<ParserComponent> intraLineComponents;

  ParserConfigs({
    required this.standaloneComponents,
    required this.intraLineComponents,
    required bool includeCoreTokens,
  }) {
    if (includeCoreTokens) {
      standaloneComponents.addAll([
        const Header1_Parser(),
        const Header2_Parser(),
        const Header3_Parser(),
        const Header4_Parser(),
        const Header5_Parser(),
        const Header6_Parser(),
      ]);
    }
  }
}
