part of markdown_parser;

abstract class ParserComponent<T extends Token> {
  const ParserComponent();

  T parse(String line, int lineNo);
  bool trigger(String line);
}

class Header1_Parser extends ParserComponent<Header1> {
  const Header1_Parser();
  @override
  bool trigger(String line) => line.startsWith('# ');
  @override
  Header1 parse(String line, int lineNo) {
    return Header1(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}

class Header2_Parser extends ParserComponent<Header2> {
  const Header2_Parser();
  @override
  bool trigger(String line) => line.startsWith('## ');
  @override
  Header2 parse(String line, int lineNo) {
    return Header2(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}

class Header3_Parser extends ParserComponent<Header3> {
  const Header3_Parser();
  @override
  bool trigger(String line) => line.startsWith('### ');
  @override
  Header3 parse(String line, int lineNo) {
    return Header3(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}

class Header4_Parser extends ParserComponent<Header4> {
  const Header4_Parser();
  @override
  bool trigger(String line) => line.startsWith('#### ');
  @override
  Header4 parse(String line, int lineNo) {
    return Header4(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}

class Header5_Parser extends ParserComponent<Header5> {
  const Header5_Parser();
  @override
  bool trigger(String line) => line.startsWith('##### ');
  @override
  Header5 parse(String line, int lineNo) {
    return Header5(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}

class Header6_Parser extends ParserComponent<Header6> {
  const Header6_Parser();
  @override
  bool trigger(String line) => line.startsWith('###### ');
  @override
  Header6 parse(String line, int lineNo) {
    return Header6(
      content: line.substring(2),
      lineNo: lineNo,
    );
  }
}
