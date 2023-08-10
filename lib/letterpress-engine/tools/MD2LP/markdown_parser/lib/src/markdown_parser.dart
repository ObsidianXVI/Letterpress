library markdown_parser;


part './parser_configs.dart';
part './parser_component.dart';
part './token.dart';
part './global_parser.dart';
part './structured_parser.dart';
part './cursor.dart';

class ParserInstance {
  final ParserConfigs configs;
  late final GlobalParser mainParser = GlobalParser(parserConfigs: configs);

  ParserInstance({
    required this.configs,
  });

  List<Token> parserString(String source) => mainParser.parseString(source);

  /* List<Token> parseString(String source) {
    final List<Token> tokens = [];
    final List<String> lines = source.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i].trim();

      /// check against line-start syntaxes
      for (ParserComponent parserComponent in configs.parserComponents) {
        if (parserComponent.trigger(line)) {
          tokens.add(parserComponent.parse(line, i));
        }
      }

      /* if (line.startsWith('# ')) {
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
      } else if (line.startsWith('```')) {
        tokens.add(
          BlockCode.parse(source, i),
        );
      } else {
        /// check intra-line syntaxes
        tokens.add(
          PlainText(content: line, lineNo: i),
        );
      } */
    }

    return tokens;
  } */
}
