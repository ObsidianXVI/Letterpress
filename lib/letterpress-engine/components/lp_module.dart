part of letterpress.ds;

class LPModule extends StatelessWidget {
  final String title;
  final DateTime publicationDate;
  final DateTime lastUpdate;
  final bool includeTableOfContents;
  final List<LPPostComponent> components;
  final List<String> tags;
  final String projectName;
  final bool renderWithPost;
  static const SizedBox componentDivider = SizedBox(height: 30);
  static const double colGutter = 40;
  static const double margin = 20;

  const LPModule({
    required this.title,
    required this.publicationDate,
    required this.lastUpdate,
    required this.includeTableOfContents,
    required this.components,
    required this.tags,
    required this.projectName,
    required this.renderWithPost,
  });

  @override
  Widget build(BuildContext context) {
    final double fullWidth = DimensionTools.getWidth(context);
    final double availableWidth = fullWidth - 2 * margin;
    final double mainColWidth = availableWidth * 0.6;
    final double sideColWidth = availableWidth * 0.2;

    final List<Widget> widgets = [];
    if (!renderWithPost) {
      widgets.addAll([
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: fullWidth,
            height: DimensionTools.getHeight(context),
            child: Center(
              child: SelectableText.rich(
                TextSpan(children: [
                  TextSpan(
                    text: title,
                    style: LPFont.mainTitle().textStyle,
                  ),
                ]),
              ),
            ),
          ),
        ),
        const LPDivider(),
        LPTableOfContents(
          postComponents: components
              .whereType<LPText>()
              .where(((LPText text) => (text.isHeader)))
              .toList(),
        ),
      ]);
    }

    for (LPPostComponent postComponent in components) {
      widgets.addAll([
        componentDivider,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: colGutter),
              child: Container(
                width: sideColWidth - colGutter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: postComponent.leftSideNotes,
                ),
              ),
            ),
            Container(
              width: mainColWidth,
              child: postComponent,
            ),
            Padding(
              padding: const EdgeInsets.only(left: colGutter),
              child: Container(
                width: sideColWidth - colGutter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: postComponent.rightSideNotes,
                ),
              ),
            ),
          ],
        ),
      ]);
    }

    if (!renderWithPost) {
      widgets.addAll([
        const LPDivider(),
        Text(
          "Published: ${publicationDate.toDateString()}",
          style: LPFont.bodyItalic().textStyle,
        ),
        Text(
          "Updated: ${lastUpdate.toDateString()}",
          style: LPFont.bodyItalic().textStyle,
        ),
      ]);
    }

    return Center(
      child: Theme(
        data: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: OctaneTheme.obsidian400.withOpacity(0.3),
            selectionHandleColor: OctaneTheme.obsidian400,
          ),
        ),
        child: SelectionArea(
          selectionControls: materialTextSelectionControls,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: widgets,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
