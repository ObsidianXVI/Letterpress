part of markdown_parser;

class GlobalParser {
  final ParserConfigs parserConfigs;

  const GlobalParser({
    required this.parserConfigs,
  });

  List<Token> parseString(String source) {
    final List<Token> tokens = [];
    final List<List<String>> sourceMatrix = [];
    void addToken(Token t) => tokens.add(t);

    for (int row = 0; row < sourceMatrix.length; row++) {
      final List<String> line = sourceMatrix[row];
      for (int col = 0; col < line.length; col++) {
        final String char = line[col];
      }
    }

    return tokens;
  }
}
