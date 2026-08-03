part of letterpress.ds;

/// A destination offered by the sticky header's navigation menu.
class LPNavDestination {
  final String label;
  final IconData icon;
  final String route;

  const LPNavDestination({
    required this.label,
    required this.icon,
    required this.route,
  });

  /// Everywhere a reader can go from inside an article.
  ///
  /// Only Home for now; the menu exists so that adding the next destination is
  /// a one-line change rather than a header redesign.
  static const List<LPNavDestination> all = <LPNavDestination>[
    LPNavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      route: LPRoutes.lp_home,
    ),
  ];
}

/// The bar that slides in once the cover image and title have scrolled away.
class RenderViewHeader extends StatefulWidget {
  final double vpWidth;
  final LPArticle article;

  /// Every heading in the article, in document order.
  final List<LPArticleSection> sections;

  /// Which of [sections] the reader is currently under, if any.
  final int? currentSectionIndex;

  final void Function(int index) onSectionSelected;

  const RenderViewHeader({
    required this.vpWidth,
    required this.article,
    this.sections = const [],
    this.currentSectionIndex,
    required this.onSectionSelected,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => RenderViewHeaderState();
}

class RenderViewHeaderState extends State<RenderViewHeader> {

  /// The chain of headings leading to the current one, outermost first.
  ///
  /// Walking backwards and keeping only headings shallower than the last one
  /// kept reconstructs the reader's position in the outline, so a subsection
  /// shows as "Intro > Some Background On This" rather than losing its parent.
  List<LPArticleSection> get breadcrumb {
    final int? index = widget.currentSectionIndex;
    if (index == null || index >= widget.sections.length) {
      return const [];
    }

    final List<LPArticleSection> trail = [widget.sections[index]];
    int shallowest = widget.sections[index].level;
    for (int i = index - 1; i >= 0; i--) {
      if (widget.sections[i].level < shallowest) {
        trail.insert(0, widget.sections[i]);
        shallowest = widget.sections[i].level;
      }
    }
    return trail;
  }

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final double height = vp.pick(mobile: 50.0, desktop: 70.0);

    // The blur has to sit behind the bar's contents rather than around them, so
    // it is a sibling in a Stack: a BackdropFilter wrapping the Row would blur
    // the text as well as what is behind it.
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          width: widget.vpWidth,
          height: height,
          decoration: BoxDecoration(
            color: LPColor.inkBlue_700.withOpacity(0.75),
            border: Border(
              bottom: BorderSide(
                color: LPColor.rollerBlue_500.withOpacity(0.2),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: vp.pick(mobile: 10.0, desktop: 20.0),
            ),
            child: Row(
              children: [
                _NavMenuButton(size: vp.pick(mobile: 34.0, desktop: 40.0)),
                SizedBox(width: vp.pick(mobile: 8.0, desktop: 16.0)),
                // The title and the breadcrumb share the remaining width. The
                // breadcrumb gets the larger share because it is the part that
                // changes as you read, and it is the harder of the two to
                // recognise when truncated.
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.article.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: body2.apply(
                      const TextStyle(color: LPColor.gripperBlue_400),
                    ),
                  ),
                ),
                if (widget.sections.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: _SectionBreadcrumb(
                        sections: widget.sections,
                        trail: breadcrumb,
                        currentSectionIndex: widget.currentSectionIndex,
                        onSectionSelected: widget.onSectionSelected,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 12),
                if (widget.article is LPPost)
                  LPSubscribeButton(
                    size: vp.pick(mobile: 34.0, desktop: 40.0),
                    target: LPSubscriptionTarget(
                      kind: LPSubscriptionKind.post,
                      slug: widget.article.title.urlSafeSlug,
                      label: widget.article.title,
                    ),
                  ),
                // The date is a nicety rather than a wayfinding aid, so it is
                // the first thing to go when the bar gets tight.
                if (vp.isDesktop) ...[
                  const SizedBox(width: 20),
                  Text(
                    widget.article.lastUpdate.toDateString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: body2.apply(
                      TextStyle(
                        color: LPColor.gripperBlue_400.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Square icon button opening the list of pages a reader can navigate to.
class _NavMenuButton extends StatelessWidget {
  final double size;

  const _NavMenuButton({required this.size});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Navigate',
      child: PopupMenuButton<LPNavDestination>(
        tooltip: '',
        position: PopupMenuPosition.under,
        color: LPColor.inkBlue_700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: LPColor.rollerBlue_500.withOpacity(0.3)),
        ),
        onSelected: (LPNavDestination destination) {
          final NavigatorState navigator = Navigator.of(context);
          if (destination.route == LPRoutes.lp_home) {
            // Unwind rather than stacking another home on top of the article,
            // so the browser's back button keeps behaving sensibly.
            navigator.popUntil((route) => route.isFirst);
          } else {
            navigator.pushNamed(destination.route);
          }
        },
        itemBuilder: (_) => LPNavDestination.all
            .map(
              (LPNavDestination destination) =>
                  PopupMenuItem<LPNavDestination>(
                value: destination,
                height: 40,
                child: Row(
                  children: [
                    Icon(
                      destination.icon,
                      size: 18,
                      color: LPColor.rollerBlue_500,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      destination.label,
                      style: body2.apply(
                        const TextStyle(color: LPColor.gripperBlue_400),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: LPColor.rollerBlue_500.withOpacity(0.1),
            border: Border.all(color: LPColor.rollerBlue_500.withOpacity(0.25)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.menu,
            size: size * 0.5,
            color: LPColor.rollerBlue_500,
          ),
        ),
      ),
    );
  }
}

/// Shows where the reader is in the outline, and jumps on request.
class _SectionBreadcrumb extends StatelessWidget {
  final List<LPArticleSection> sections;
  final List<LPArticleSection> trail;
  final int? currentSectionIndex;
  final void Function(int index) onSectionSelected;

  const _SectionBreadcrumb({
    required this.sections,
    required this.trail,
    required this.currentSectionIndex,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final String label =
        trail.isEmpty ? 'Jump to section' : trail.map((s) => s.title).join('  ›  ');

    return PopupMenuButton<int>(
      tooltip: '',
      position: PopupMenuPosition.under,
      color: LPColor.inkBlue_700,
      constraints: const BoxConstraints(maxWidth: 420, maxHeight: 420),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: LPColor.rollerBlue_500.withOpacity(0.3)),
      ),
      onSelected: onSectionSelected,
      itemBuilder: (_) => List<PopupMenuEntry<int>>.generate(
        sections.length,
        (int i) {
          final LPArticleSection section = sections[i];
          final bool isCurrent = i == currentSectionIndex;
          return PopupMenuItem<int>(
            value: i,
            height: 38,
            child: Padding(
              // Indenting by depth makes the outline readable at a glance
              // without needing numbering.
              padding: EdgeInsets.only(left: (section.level - 1) * 14.0),
              child: Text(
                section.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: body2.apply(
                  TextStyle(
                    color: isCurrent
                        ? LPColor.chaseRed_500
                        : LPColor.gripperBlue_400.withOpacity(0.85),
                    fontWeight: isCurrent ? FontWeight.w600 : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: body2.apply(
                  TextStyle(
                    color: trail.isEmpty
                        ? LPColor.gripperBlue_400.withOpacity(0.4)
                        : LPColor.gripperBlue_400,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.expand_more,
              size: 18,
              color: LPColor.rollerBlue_500.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}
