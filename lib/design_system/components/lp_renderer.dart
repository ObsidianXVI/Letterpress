part of letterpress.ds;

class LPRenderer extends StatefulWidget {
  final bool includeTableOfContents;
  final bool includeMetaDetails;
  final LPArticle article;

  const LPRenderer({
    required this.article,
    this.includeMetaDetails = true,
    this.includeTableOfContents = false,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => LPRendererState();
}

class LPRendererState extends State<LPRenderer> {
  final double gutterRatio =
      Multiplatform.currentPlatform == const DesktopPlatform() ? 0.04 : 0.05;
  static const SizedBox componentDivider = SizedBox(height: 30);
  bool coverInView = true;

  @override
  Widget build(BuildContext context) {
    late final double vpWidth = DimensionTools.getWidth(context);

    /// Automatically-decided gutter to include between content and side notes,
    /// based on the platform.
    late final double colGutter = Dimensions.width() * gutterRatio;
    final double contentWidth = vpWidth - colGutter * 2;

    /// The width for available for the body text. Equal to [contentWidth] on mobile.
    final double mainColWidth = contentWidth *
        (Multiplatform.currentPlatform == const DesktopPlatform() ? 0.6 : 1);

    /// The width for each "side notes" column
    final double sideColWidth = contentWidth * 0.22;

    final List<Widget> widgets = [];
    if (widget.includeTableOfContents) {
      widgets.add(
        renderComponent(
          postComponent: LPTableOfContents(
            postComponents: widget.article.components
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
      );
    }

    for (LPPostComponent postComponent in widget.article.components) {
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

    if (widget.includeMetaDetails) {
      widgets.addAll([
        const LPDivider(),
        Text(
          "Published: ${widget.article.publicationDate.toDateString()}",
          style: body.apply(TextStyle(
            fontStyle: FontStyle.italic,
            color: LPColor.rollerBlue_500.withOpacity(0.8),
          )),
        ),
        Text(
          "Updated: ${widget.article.lastUpdate.toDateString()}",
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
              if (widget.article.coverImgName != null)
                Positioned.fill(
                  child: Image.asset(
                    'images/covers/${widget.article.coverImgName}.png',
                    fit: BoxFit.cover,
                  ),
                ),
              SingleChildScrollView(
                child: SizedBox(
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
                              child: VisibilityDetector(
                                key: const Key('title_key'),
                                onVisibilityChanged: (VisibilityInfo info) {
                                  if (info.visibleFraction > 0) {
                                    setState(() {
                                      coverInView = true;
                                    });
                                  } else if (info.visibleFraction == 0) {
                                    setState(() {
                                      coverInView = false;
                                    });
                                  }
                                },
                                child: SelectableText.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: widget.article.title,
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
              if (!coverInView)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    width: vpWidth,
                    height:
                        Multiplatform.currentPlatform == const DesktopPlatform()
                            ? 80
                            : 60,
                    color: LPColor.inkBlue_500,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.article.title,
                          style: header3.apply(
                              const TextStyle(color: LPColor.gripperBlue_400)),
                        ),
                      ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
