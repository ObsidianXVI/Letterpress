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
  static const SizedBox componentDivider = SizedBox(height: 30);
  static const double _desktopHeaderHeight = 72;
  static const double _mobileHeaderHeight = 58;

  final ScrollController _scrollController = ScrollController();

  bool coverInView = true;
  bool _sectionRefreshQueued = false;
  late List<LPSectionEntry> _sections;
  LPSectionEntry? _currentSection;

  @override
  void initState() {
    super.initState();
    _rebuildSections();
    _scrollController.addListener(_queueSectionRefresh);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshCurrentSection(),
    );
  }

  @override
  void didUpdateWidget(covariant LPRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.article != widget.article) {
      _rebuildSections();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _refreshCurrentSection(),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double vpWidth = DimensionTools.getWidth(context);
    final double gutterRatio =
        Multiplatform.currentPlatform == const DesktopPlatform() ? 0.04 : 0.05;
    final double colGutter = vpWidth * gutterRatio;
    final double contentWidth = vpWidth - colGutter * 2;
    final double mainColWidth =
        contentWidth *
        (Multiplatform.currentPlatform == const DesktopPlatform() ? 0.6 : 1);
    final double sideColWidth = contentWidth * 0.22;

    final List<Widget> widgets = [];
    if (widget.includeTableOfContents) {
      widgets.add(
        renderComponent(
          postComponent: LPTableOfContents(
            postComponents: widget.article.components
                .whereType<LPText>()
                .where((LPText text) => text.isHeader)
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

    for (int i = 0; i < widget.article.components.length; i++) {
      final LPPostComponent postComponent = widget.article.components[i];
      Widget component = renderComponent(
        postComponent: postComponent,
        sideColWidth: sideColWidth,
        mainColWidth: mainColWidth,
        leftSideNotes: postComponent.leftSideNotes,
        rightSideNotes: postComponent.rightSideNotes,
        colGutter: colGutter,
      );

      final LPSectionEntry? section = _sectionForComponentIndex(i);
      if (section != null) {
        component = KeyedSubtree(key: section.anchorKey, child: component);
      }

      widgets.addAll([componentDivider, component]);
    }

    if (widget.includeMetaDetails) {
      widgets.addAll([
        const LPDivider(),
        Text(
          "Published: ${widget.article.publicationDate.toDateString()}",
          style: body.apply(
            TextStyle(
              fontStyle: FontStyle.italic,
              color: LPColor.rollerBlue_500.withOpacity(0.8),
            ),
          ),
        ),
        Text(
          "Updated: ${widget.article.lastUpdate.toDateString()}",
          style: body.apply(
            TextStyle(
              fontStyle: FontStyle.italic,
              color: LPColor.rollerBlue_500.withOpacity(0.8),
            ),
          ),
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
        child: Stack(
          children: [
            if (widget.article.coverImgName != null)
              Positioned.fill(
                child: Image.asset(
                  'images/covers/${widget.article.coverImgName}.png',
                  fit: BoxFit.cover,
                ),
              ),
            SelectionArea(
              child: SingleChildScrollView(
                controller: _scrollController,
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
                          Positioned(
                            left: colGutter,
                            bottom: 50,
                            right: colGutter,
                            child: VisibilityDetector(
                              key: const Key('title_key'),
                              onVisibilityChanged: (VisibilityInfo info) {
                                final bool nextCoverInView =
                                    info.visibleFraction > 0;
                                if (nextCoverInView != coverInView) {
                                  setState(() {
                                    coverInView = nextCoverInView;
                                  });
                                }
                              },
                              child: _LPSelectableRichText(
                                spans: [
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
                child: ClipRect(
                  child: RenderViewHeader(
                    vpWidth: vpWidth,
                    article: widget.article,
                    currentSection: _currentSection,
                    sections: _sections,
                    onSectionSelected: _jumpToSection,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _rebuildSections() {
    final List<LPSectionEntry> nextSections = [];
    final Map<int, String> sectionTrail = <int, String>{};

    for (int i = 0; i < widget.article.components.length; i++) {
      final LPPostComponent component = widget.article.components[i];
      if (component is! LPText || !component.isHeader) {
        continue;
      }

      sectionTrail.removeWhere((int key, String value) {
        return key >= component.headingLevel;
      });
      sectionTrail[component.headingLevel] = component.headingLabel;

      final List<String> breadcrumbParts = <String>[
        for (int level = 1; level <= component.headingLevel; level++)
          if ((sectionTrail[level] ?? '').isNotEmpty) sectionTrail[level]!,
      ];

      nextSections.add(
        LPSectionEntry(
          componentIndex: i,
          level: component.headingLevel,
          title: component.headingLabel,
          breadcrumb: breadcrumbParts.join(' > '),
          anchorKey: GlobalKey(),
        ),
      );
    }

    _sections = nextSections;
    _currentSection = nextSections.isNotEmpty ? nextSections.first : null;
  }

  LPSectionEntry? _sectionForComponentIndex(int index) {
    for (final LPSectionEntry section in _sections) {
      if (section.componentIndex == index) {
        return section;
      }
    }
    return null;
  }

  void _queueSectionRefresh() {
    if (_sectionRefreshQueued || !mounted) {
      return;
    }

    _sectionRefreshQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sectionRefreshQueued = false;
      if (!mounted) {
        return;
      }
      _refreshCurrentSection();
    });
  }

  void _refreshCurrentSection() {
    if (_sections.isEmpty) {
      return;
    }

    final double anchorLine = _headerHeight(context) + 24;
    LPSectionEntry? lastPassedSection;
    LPSectionEntry? firstUpcomingSection;

    for (final LPSectionEntry section in _sections) {
      final BuildContext? sectionContext = section.anchorKey.currentContext;
      if (sectionContext == null) {
        continue;
      }

      final RenderObject? renderObject = sectionContext.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) {
        continue;
      }

      final double top = renderObject.localToGlobal(Offset.zero).dy;
      if (top <= anchorLine) {
        lastPassedSection = section;
      } else {
        firstUpcomingSection ??= section;
      }
    }

    final LPSectionEntry? nextSection =
        lastPassedSection ?? firstUpcomingSection;
    if (nextSection != null && nextSection != _currentSection) {
      setState(() {
        _currentSection = nextSection;
      });
    }
  }

  void _jumpToSection(LPSectionEntry section) {
    final BuildContext? sectionContext = section.anchorKey.currentContext;
    if (sectionContext == null || !_scrollController.hasClients) {
      return;
    }

    final RenderObject? renderObject = sectionContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return;
    }

    final double targetOffset =
        renderObject.localToGlobal(Offset.zero).dy +
        _scrollController.offset -
        _headerHeight(context) -
        24;

    _scrollController.animateTo(
      targetOffset
          .clamp(0, _scrollController.position.maxScrollExtent)
          .toDouble(),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  double _headerHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 900
        ? _desktopHeaderHeight
        : _mobileHeaderHeight;
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
        SizedBox(width: mainColWidth, child: postComponent),
        if (Multiplatform.currentPlatform == const DesktopPlatform())
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
