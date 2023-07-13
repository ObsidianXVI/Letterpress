part of markdown_parser;

class GlobalParser {
  final ParserConfigs parserConfigs;

  const GlobalParser({
    required this.parserConfigs,
  });

  List<Token> parseString(String source) {
    final List<Token> tokens = [];
    final SourceMap sourceMap = SourceMap(source: source);
    void addToken(Token t) => tokens.add(t);

/*     for (int row = 0; row < sourceMap.totalRows; row++) {
      final List<String> line = sourceMap.chars[row];
      for (ParserComponent pc in parserConfigs.lineTriggeredParsers) {
        if (pc.trigger(source)) {
          final CursorLocation newCursorLoc = pc.parse(sourceMap, addToken);
          sourceMap.currentLocation = newCursorLoc;
        }
      }
      for (int col = 0; col < line.length; col++) {
        final String char = line[col];
        for (ParserComponent pc in parserConfigs.charTriggeredParsers) {
          if (pc.trigger(source)) {
            final CursorLocation newCursorLoc = pc.parse(sourceMap, addToken);
            sourceMap.currentLocation = newCursorLoc;
          }
        }
      }
    } */

    while (sourceMap.currentLocation != sourceMap.endLoc) {
      final List<String> line = sourceMap.chars[sourceMap.currentLocation.row];
      for (ParserComponent pc in parserConfigs.lineTriggeredParsers) {
        if (pc.trigger(line.join())) {
          final CursorLocation newCursorLoc = pc.parse(sourceMap, addToken);
          sourceMap.currentLocation = newCursorLoc;
        }
      }
      final String char = line[sourceMap.currentLocation.col];
      for (ParserComponent pc in parserConfigs.charTriggeredParsers) {
        if (pc.trigger(char)) {
          final CursorLocation newCursorLoc = pc.parse(sourceMap, addToken);
          sourceMap.currentLocation = newCursorLoc;
        }
      }
    }

    return tokens;
  }
}
