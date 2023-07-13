part of markdown_parser;

mixin StructuredParsing<T extends Token> on ParserComponent<T> {
  StructuredToken parseStructured(SourceMap sourceMap) {
    final Map<String, dynamic> params = {};
    final String _a = sourceMap.consumeChar();
    final List<String> identChars = sourceMap.consumeUntil('{');
    final String _openBrace = sourceMap.consumeChar();
    return StructuredToken(
      identifier: identChars.join(),
      content: _a + _openBrace + identChars.join(),
      params: params,
      cursorLocation: sourceMap.currentLocation,
    );
  }
}
