part of letterpress.ds;

enum LPListType {
  bullet,
  numbered,
  chaptered,
  ;
}

class LPList extends LPPostComponent {
  final LPListType lpListType;

  /// The key is the hierarchy level of the list item, and is > 0
  /// The value is the text to be indented
  final Map<LPText, int> indentLevels;

  const LPList({
    super.leftSideNotes,
    super.rightSideNotes,
    required this.lpListType,
    required this.indentLevels,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    final LPText Function(MapEntry<LPText, int>) itemGeneratorFn;
    switch (lpListType) {
      case LPListType.bullet:
        itemGeneratorFn = (MapEntry<LPText, int> entry) {
          return LPText.plainBody(
            content: "${'   ' * 2 * entry.value}•${entry.key.content}",
          );
        };
        break;
      case LPListType.numbered:
        int itemNo = 0;
        itemGeneratorFn = (MapEntry<LPText, int> entry) {
          itemNo += 1;
          return LPText.plainBody(
            content: "${'   ' * 2 * entry.value}$itemNo${entry.key.content}",
          );
        };
        break;
      case LPListType.chaptered:
        int l1No = -1;
        int l2No = -1;
        int l3No = -1;
        final int maxDepth = indentLevels.entries.isNotEmpty
            ? indentLevels.entries
                .reduce(
                  (value, element) => value.key.lpFont.headerLevel >
                          element.key.lpFont.headerLevel
                      ? element
                      : value,
                )
                .key
                .lpFont
                .headerLevel
            : 0;
        itemGeneratorFn = (MapEntry<LPText, int> entry) {
          final String chapterCode;
          switch (entry.value) {
            case 1:
              l1No += 1;
              l2No = -1;
              l3No = -1;
              chapterCode = l1Chapters[l1No];
              break;
            case 2:
              l2No += 1;
              chapterCode = l2Chapters[l2No];
              break;
            case 3:
              l3No += 1;
              chapterCode = l3Chapters[l3No];
              break;
            default:
              l3No += 1;
              chapterCode = l3Chapters[l3No];
          }
          return LPText.plainBody(
            content:
                "${'   ' * 2 * entry.value}$chapterCode: ${entry.key.content}",
          );
        };
        break;
    }

    for (MapEntry<LPText, int> entry in indentLevels.entries) {
      children.addAll([itemGeneratorFn(entry), LPPost.componentDivider]);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  static const List<String> l1Chapters = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26'
  ];

  static const List<String> l2Chapters = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];

  static const List<String> l3Chapters = [
    'i',
    'ii',
    'iii',
    'iv',
    'v',
    'vi',
    'vii',
    'viii',
    'ix',
    'x',
  ];
}
