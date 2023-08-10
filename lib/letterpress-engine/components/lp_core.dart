part of letterpress.ds;

extension LPPostComponentUtils on List<LPPostComponent> {
  void insertTableOfContents(int index) {
    /* final LPTableOfContents tableOfContents = LPTableOfContents(
      postComponents: whereType<LPText>()
          .where(((LPText text) => (text.isHeader)))
          .cast<LPText>()
          .toList(),
    );
    print('start');
    insert(
      index,
      tableOfContents,
    ); */
  }
}

extension DateUtils on DateTime {
  static const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String toDateString() {
    final List<String> chunks = [];
    chunks.addAll([
      day.toString().padLeft(2, '0'),
      monthNames[month],
      year.toString(),
    ]);
    return chunks.join(' ');
  }
}
