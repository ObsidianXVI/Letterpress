library markdown_parser;

part './parser_configs.dart';
part './token.dart';

class MarkdownParser {
  final ParserConfigs configs;

  const MarkdownParser({
    required this.configs,
  });

  List<Token> parseString(String source) {
    final List<Token> tokens = [];
    final List<String> lines = source.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i].trim();
      if (line.startsWith('# ')) {
        tokens.add(
          Header1(
            content: line.substring(2),
            lineNo: i,
          ),
        );
      } else if (line.startsWith('## ')) {
        tokens.add(
          Header2(
            content: line.substring(2),
            lineNo: i,
          ),
        );
      } else if (line.startsWith('### ')) {
        tokens.add(
          Header3(
            content: line.substring(2),
            lineNo: i,
          ),
        );
      } else if (line.startsWith('#### ')) {
        tokens.add(
          Header4(
            content: line.substring(2),
            lineNo: i,
          ),
        );
      } else if (line.startsWith('##### ')) {
        tokens.add(
          Header5(
            content: line.substring(2),
            lineNo: i,
          ),
        );
      } else if (line.startsWith('###### ')) {
        tokens.add(
          Header6(
            content: line.substring(2),
            lineNo: i,
          ),
        );
      } else if (line.startsWith('> ')) {
        tokens.add(
          PullQuote.parse(source, i),
        );
      }
    }
    return tokens;
  }
}
