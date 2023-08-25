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
  Widget render(BuildContext context) {
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
        int itemNo = 0;
        final int maxDepth = indentLevels.entries
            .reduce(
              (value, element) =>
                  value.key.lpFont.headerLevel > element.key.lpFont.headerLevel
                      ? element
                      : value,
            )
            .key
            .lpFont
            .headerLevel;
        List<int> chapterCode = List<int>.generate(maxDepth, (index) => 0);
        itemGeneratorFn = (MapEntry<LPText, int> entry) {
          itemNo += 1;
          return LPText.plainBody(
            content:
                "${'   ' * 2 * entry.value}${entry.value}${entry.key.content}",
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
}
