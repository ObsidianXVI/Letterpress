part of letterpress.ds;

/// One heading in an article, as tracked by the sticky header.
class LPArticleSection {
  /// Heading text as it appears in the article.
  final String title;

  /// Outline depth, mirroring [LPText.headerLevel]: 1 is a piece title,
  /// descending to 4 for the smallest heading.
  final int level;

  /// Anchors the heading in the tree so its position can be measured while
  /// scrolling and scrolled back to when picked from the dropdown.
  final GlobalKey key;

  LPArticleSection({
    required this.title,
    required this.level,
  }) : key = GlobalKey();
}

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
  static const SizedBox componentDivider = SizedBox(height: 30);

  final ScrollController scrollController = ScrollController();

  /// Every heading in the article, in document order.
  late final List<LPArticleSection> sections = widget.article.components
      .whereType<LPText>()
      .where((LPText text) => text.isHeader)
      .map((LPText text) =>
          LPArticleSection(title: text.content, level: text.headerLevel))
      .toList();

  /// Index into [sections] of the heading the reader is currently under, or
  /// null while still above the first one.
  int? currentSectionIndex;

  bool coverInView = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(updateCurrentSection);
  }

  @override
  void dispose() {
    scrollController.removeListener(updateCurrentSection);
    scrollController.dispose();
    super.dispose();
  }

  double get headerHeight =>
      LPViewport.maybeOf(context)?.isMobile ?? false ? 50 : 70;

  /// Finds the last heading that has scrolled up past the sticky header.
  ///
  /// Headings are measured rather than tracked by accumulated offsets because
  /// article components have wildly varying heights and the body text reflows
  /// with the viewport, so any precomputed offset table would go stale.
  void updateCurrentSection() {
    if (!mounted) return;

    final double threshold = headerHeight + 8;
    int? found;
    for (int i = 0; i < sections.length; i++) {
      final BuildContext? sectionContext = sections[i].key.currentContext;
      if (sectionContext == null) continue;
      final RenderBox? box = sectionContext.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy <= threshold) {
        found = i;
      } else {
        break;
      }
    }

    if (found != currentSectionIndex) {
      setState(() => currentSectionIndex = found);
    }
  }

  /// Scrolls a heading to just below the sticky header.
  void jumpToSection(int index) {
    final BuildContext? sectionContext = sections[index].key.currentContext;
    if (sectionContext == null) return;
    final RenderBox? box = sectionContext.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;

    final double delta = box.localToGlobal(Offset.zero).dy - headerHeight - 8;
    final double target = (scrollController.offset + delta)
        .clamp(0.0, scrollController.position.maxScrollExtent);

    scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    final double vpWidth = vp.size.width;
    final double vpHeight = DimensionTools.getHeight(context);

    /// Automatically-decided gutter to include between content and side notes,
    /// based on the platform.
    final double colGutter = vpWidth * vp.pick(mobile: 0.05, desktop: 0.04);
    final double contentWidth = vpWidth - colGutter * 2;

    /// The width available for the body text. Equal to [contentWidth] on mobile.
    final double mainColWidth =
        contentWidth * vp.pick(mobile: 1.0, desktop: 0.6);

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
          isDesktop: vp.isDesktop,
        ),
      );
    }

    int headingCursor = 0;
    for (LPPostComponent postComponent in widget.article.components) {
      // Headings are keyed in the same order they were collected into
      // [sections], which is what lets the sticky header locate them.
      Key? sectionKey;
      if (postComponent is LPText && postComponent.isHeader) {
        sectionKey = sections[headingCursor].key;
        headingCursor += 1;
      }

      widgets.addAll([
        componentDivider,
        renderComponent(
          postComponent: postComponent,
          sideColWidth: sideColWidth,
          mainColWidth: mainColWidth,
          leftSideNotes: postComponent.leftSideNotes,
          rightSideNotes: postComponent.rightSideNotes,
          colGutter: colGutter,
          isDesktop: vp.isDesktop,
          sectionKey: sectionKey,
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
        const SizedBox(height: 60),
      ]);
    }

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: OctaneTheme.obsidianB100.withOpacity(0.3),
          selectionHandleColor: OctaneTheme.obsidianB150,
        ),
      ),
      child: Stack(
        children: [
          if (widget.article.coverImgName != null)
            Positioned.fill(
              child: Image.asset(
                'assets/images/covers/${widget.article.coverImgName}.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(
                  width: vpWidth,
                  height: vpHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: double.infinity,
                          height: vpHeight * 0.25,
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
                            if (!mounted) return;
                            final bool visible = info.visibleFraction > 0;
                            if (visible != coverInView) {
                              setState(() => coverInView = visible);
                            }
                          },
                          child: Text(
                            widget.article.title,
                            style: pieceTitle.apply(
                              const TextStyle(
                                color: LPColor.gripperBlue_500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: LPColor.inkBlue_700,
                  child: Column(children: widgets),
                ),
              ],
            ),
          ),
          if (!coverInView)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: RenderViewHeader(
                vpWidth: vpWidth,
                article: widget.article,
                sections: sections,
                currentSectionIndex: currentSectionIndex,
                onSectionSelected: jumpToSection,
              ),
            ),
        ],
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
    required bool isDesktop,
    Key? sectionKey,
  }) {
    return Row(
      key: sectionKey,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop)
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
        if (isDesktop)
          Padding(
            padding: EdgeInsets.only(left: colGutter),
            child: SizedBox(
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
