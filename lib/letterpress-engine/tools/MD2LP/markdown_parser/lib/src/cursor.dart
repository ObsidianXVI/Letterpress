part of markdown_parser;

class CursorLocation {
  final int row;
  final int col;

  const CursorLocation({
    required this.row,
    required this.col,
  });
}

class SourceMap {
  CursorLocation currentLocation = CursorLocation(row: 0, col: 0);
  final String source;
  late final List<List<String>> chars =
      source.split('\n').map((String line) => line.split('')).toList();

  SourceMap({
    required this.source,
  });

  List<String> get currentLineChars => chars[currentLocation.row];
  List<List<String>> get charsLeftFromCurrent {
    final List<List<String>> rowsLeft = chars.sublist(currentLocation.row);
    if (rowsLeft.isNotEmpty) {
      rowsLeft.first.removeRange(0, currentLocation.col - 1);
    }
    return rowsLeft;
  }
}
