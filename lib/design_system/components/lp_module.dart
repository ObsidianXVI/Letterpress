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
        Center(
          child: Container(
            width: fullWidth,
            color: LPColor.inkBlue_500,
            height: DimensionTools.getHeight(context),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                      child: Container(
                        width: double.infinity,
                        height: DimensionTools.getHeight(context) * 0.25,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              LPColor.inkBlue_700,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  bottom: 50,
                  right: 30,
                  child: SelectableText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: pieceTitle.apply(
                              const TextStyle(color: LPColor.gripperBlue_500)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const LPDivider(),
        if (includeTableOfContents)
          renderComponent(
            postComponent: LPTableOfContents(
              postComponents: components
                  .whereType<LPText>()
                  .where(((LPText text) => (text.isHeader)))
                  .toList(),
            ),
            sideColWidth: sideColWidth,
            mainColWidth: mainColWidth,
            leftSideNotes: const [],
            rightSideNotes: const [],
          ),
      ]);
    }

    for (LPPostComponent postComponent in components) {
      widgets.addAll([
        componentDivider,
        renderComponent(
          postComponent: postComponent,
          sideColWidth: sideColWidth,
          mainColWidth: mainColWidth,
          leftSideNotes: postComponent.leftSideNotes,
          rightSideNotes: postComponent.rightSideNotes,
        ),
      ]);
    }

    if (!renderWithPost) {
      widgets.addAll([
        const LPDivider(),
        Text(
          "Published: ${publicationDate.toDateString()}",
          style: body.apply(TextStyle(
            fontStyle: FontStyle.italic,
            color: LPColor.rollerBlue_500.withOpacity(0.8),
          )),
        ),
        Text(
          "Updated: ${lastUpdate.toDateString()}",
          style: body.apply(TextStyle(
            fontStyle: FontStyle.italic,
            color: LPColor.rollerBlue_500.withOpacity(0.8),
          )),
        ),
      ]);
    }

    return Center(
      child: Theme(
        data: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: OctaneTheme.obsidianB100.withOpacity(0.3),
            selectionHandleColor: OctaneTheme.obsidianB150,
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

  Widget renderComponent({
    required LPPostComponent postComponent,
    required double sideColWidth,
    required double mainColWidth,
    required List<LPSideNoteComponent> leftSideNotes,
    required List<LPSideNoteComponent> rightSideNotes,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: colGutter),
          child: Container(
            width: sideColWidth - colGutter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: leftSideNotes,
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
              children: rightSideNotes,
            ),
          ),
        ),
      ],
    );
  }
}
