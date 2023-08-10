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
    final List<Widget> widgets = [];
    if (!renderWithPost) {
      widgets.addAll([
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: DimensionTools.getWidth(context),
            height: DimensionTools.getHeight(context),
            child: Center(
              child: SelectableText.rich(
                TextSpan(children: [
                  TextSpan(
                    text: title,
                    style: LPFont.title().textStyle,
                  ),
                ]),
              ),
            ),
          ),
        ),
        const LPDivider(),
      ]);
    }

    for (LPPostComponent postComponent in components) {
      widgets.addAll([
        componentDivider,
        postComponent,
      ]);
    }

    if (!renderWithPost) {
      final LPTableOfContents tableOfContents = LPTableOfContents(
        postComponents: widgets
            .whereType<LPText>()
            .where(((LPText text) => (text.isHeader)))
            .toList(),
      );
      widgets.insert(1, tableOfContents);
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
      child: Padding(
        padding: const EdgeInsets.only(left: 200, right: 200),
        child: Theme(
          data: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: LPTheme.grey400.withOpacity(0.3),
              selectionHandleColor: LPTheme.grey400,
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
      ),
    );
  }
}
