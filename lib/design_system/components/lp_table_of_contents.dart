part of letterpress.ds;

class LPTableOfContents extends LPPostComponent {
  final List<LPText> postComponents;
  const LPTableOfContents({
    required this.postComponents,
  });

  @override
  Widget build(BuildContext context) {
    final Map<LPText, int> indentLevels = Map.fromIterables(
      postComponents.map((LPText lpText) => lpText),
      postComponents.map((LPText lpText) => 1), //lpText.lpFont.headerLevel
    );

    return LPGroup.vertical(
      postComponents: [
        LPText.header1(content: 'Outline'),
        /* LPList(
          lpListType: LPListType.chaptered,
          indentLevels: indentLevels,
        ), */
      ],
    );
  }
}
