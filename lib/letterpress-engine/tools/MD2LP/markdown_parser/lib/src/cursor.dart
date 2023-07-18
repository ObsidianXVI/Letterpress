part of markdown_parser;

class CursorLocation {
  final int row;
  final int col;

  const CursorLocation({
    required this.row,
    required this.col,
  });

  operator +(CursorLocation other) =>
      CursorLocation(row: row + other.row, col: col + other.col);

  @override
  operator ==(Object other) {
    if (other is! CursorLocation) return false;
    if (other.row == row && other.col == col) return true;
    return false;
  }

  @override
  String toString() => "CL<$row, $col>";
}

class SourceMap {
  CursorLocation currentLocation = CursorLocation(row: 0, col: 0);
  final String source;
  late final List<List<String>> chars =
      source.split('\n').map((String line) => line.split('')).toList();
  late final int totalRows = chars.length;
  late final CursorLocation endLoc =
      CursorLocation(row: totalRows, col: chars.last.length);

  SourceMap({
    required this.source,
  });

  List<String> get currentLineChars => chars[currentLocation.row];
  List<List<String>> get charMapFromCurrent {
    final List<List<String>> rowsLeft = chars.sublist(currentLocation.row);
    if (rowsLeft.isNotEmpty) {
      rowsLeft.first.removeRange(0, currentLocation.col - 1);
    }
    return rowsLeft;
  }

  List<String> get charListFromCurrent {
    final List<List<String>> rowsLeft = chars.sublist(currentLocation.row);
    if (rowsLeft.isNotEmpty) {
      rowsLeft.first.removeRange(0, currentLocation.col - 1);
    }
    return [for (List<String> r in rowsLeft) ...r];
  }

  String consumeChar([int count = 1]) {
    final List<String> consumedChars = [];
    currentLocation = advanceCursor(
      count,
      (List<String> newChars) => consumedChars.addAll(newChars),
    );
    print(consumedChars);
    return consumedChars.last;
  }

  List<String> consumeUntil(String stopChar) {
    final List<String> consumedChars = [];
    while (peekChar() != stopChar) {
      consumedChars.add(consumeChar());
    }
    return consumedChars;
  }

  String peekChar([int lookAhead = 1]) {
    final List<String> consumedChars = [];
    advanceCursor(
      lookAhead,
      (List<String> newChars) => consumedChars.addAll(newChars),
    );
    return consumedChars.last;
  }

  CursorLocation advanceCursor(
    int count, [
    void Function(List<String>)? addChars,
  ]) {
    List<String> currentRow = chars[currentLocation.row];
    final int rowLength = currentRow.length;
    CursorLocation newLoc = currentLocation;
    final int currentCol = currentLocation.col;
    if (currentCol + count < rowLength) {
      newLoc = currentLocation + CursorLocation(row: 0, col: count);
      addChars?.call(currentRow.sublist(currentCol, newLoc.col));
      return newLoc;
    } else {
      while (true) {
        newLoc = CursorLocation(row: newLoc.row + 1, col: 0);
        addChars?.call(currentRow);
        currentRow.clear();
        currentRow = chars[newLoc.row];
        if (count < currentRow.length) {
          addChars?.call(currentRow.sublist(0, count));
          return newLoc + CursorLocation(row: 0, col: count);
        } else {
          count -= currentRow.length;
        }
      }
    }
  }

  String charAt(CursorLocation loc) => chars[loc.row][loc.col];
}
