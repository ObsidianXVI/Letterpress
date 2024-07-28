part of letterpress.ds;

class LPModule extends StatelessWidget {
  final String title;
  final String? coverImgName;
  final DateTime publicationDate;
  final DateTime lastUpdate;
  final bool includeTableOfContents;
  final List<LPPostComponent> components;
  final List<String> tags;
  final String projectName;
  final bool renderWithPost;
  final double gutterRatio =
      Multiplatform.currentPlatform == const DesktopPlatform() ? 0.1 : 0.05;
  static const SizedBox componentDivider = SizedBox(height: 30);

  LPModule({
    required this.title,
    required this.publicationDate,
    required this.lastUpdate,
    required this.includeTableOfContents,
    required this.components,
    required this.tags,
    required this.projectName,
    required this.renderWithPost,
    this.coverImgName,
  });

  @override
  Widget build(BuildContext context) {
    late final double vpWidth = DimensionTools.getWidth(context);

    /// Automatically decided gutter to include between content and edges of the screen,
    /// based on the platform.
    late final double colGutter = Dimensions.width() * gutterRatio;
    final double contentWidth = vpWidth - colGutter * 2;

    /// The width for available for the body text. Equal to [contentWidth] on mobile.
    final double mainColWidth = contentWidth *
        (Multiplatform.currentPlatform == const DesktopPlatform() ? 0.6 : 1);

    /// The width for each "side notes" column
    final double sideColWidth = contentWidth * 0.2;

    final List<Widget> widgets = [];
    if (!renderWithPost) {
      widgets.addAll([
        // const LPDivider(),
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
            colGutter: colGutter,
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
          colGutter: colGutter,
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
        child: Center(
          child: Stack(
            children: [
              if (coverImgName != null)
                Positioned.fill(
                  child: Image.asset(
                    'images/covers/$coverImgName.png',
                    fit: BoxFit.cover,
                  ),
                ),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        width: vpWidth,
                        height: DimensionTools.getHeight(context),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: double.infinity,
                                height:
                                    DimensionTools.getHeight(context) * 0.25,
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
                            Positioned(
                              left: colGutter,
                              bottom: 50,
                              right: colGutter,
                              child: SelectableText.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: title,
                                      style: pieceTitle.apply(
                                        const TextStyle(
                                          color: LPColor.gripperBlue_500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: LPColor.inkBlue_700,
                        child: Column(children: widgets),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
    required double colGutter,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Multiplatform.currentPlatform == const DesktopPlatform())
          Padding(
            padding: EdgeInsets.only(right: colGutter),
            child: SizedBox(
              width: sideColWidth - colGutter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: leftSideNotes,
              ),
            ),
          ),
        SizedBox(
          width: mainColWidth,
          child: postComponent,
        ),
        if (Multiplatform.currentPlatform == const DesktopPlatform())
          Padding(
            padding: EdgeInsets.only(left: colGutter),
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
