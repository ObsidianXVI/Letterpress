part of letterpress.ds;

class LPTableOfContents extends LPPostComponent {
  final List<LPText> postComponents;
  const LPTableOfContents({required this.postComponents});

  @override
  Widget build(BuildContext context) {
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
