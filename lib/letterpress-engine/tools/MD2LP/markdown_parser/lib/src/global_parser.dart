part of markdown_parser;

class GlobalParser {
  final ParserConfigs parserConfigs;

  const GlobalParser({
    required this.parserConfigs,
  });

  List<Token> parseString(String source) {
    final List<Token> tokens = [];
    final SourceMap sourceMap = SourceMap(source: source);

    while (sourceMap.currentLocation != sourceMap.endLoc) {
      final List<String> line = sourceMap.chars[sourceMap.currentLocation.row];
      for (ParserComponent pc in parserConfigs.lineTriggeredParsers) {
        if (pc.trigger(line.join())) pc.parse(sourceMap);
      }
      final String char = line[sourceMap.currentLocation.col];
      for (ParserComponent pc in parserConfigs.charTriggeredParsers) {
        if (pc.trigger(char)) pc.parse(sourceMap);
      }
    }

    return tokens;
  }
}
