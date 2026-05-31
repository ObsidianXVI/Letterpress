part of letterpress.ds;

class LPSectionEntry {
  final int componentIndex;
  final int level;
  final String title;
  final String breadcrumb;
  final GlobalKey anchorKey;

  LPSectionEntry({
    required this.componentIndex,
    required this.level,
    required this.title,
    required this.breadcrumb,
    required this.anchorKey,
  });
}

class RenderViewHeader extends StatefulWidget {
  final double vpWidth;
  final LPArticle article;
  final LPSectionEntry? currentSection;
  final List<LPSectionEntry> sections;
  final ValueChanged<LPSectionEntry> onSectionSelected;

  const RenderViewHeader({
    required this.vpWidth,
    required this.article,
    required this.currentSection,
    required this.sections,
    required this.onSectionSelected,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => RenderViewHeaderState();
}

class RenderViewHeaderState extends State<RenderViewHeader> {
  bool isSubscribedToPost = false;

  @override
  Widget build(BuildContext context) {
    final bool isWide = widget.vpWidth >= 900;
    final bool showMeta = widget.vpWidth >= 720;
    final double horizontalPadding = isWide ? 24 : 16;
    final String sectionLabel =
        widget.currentSection?.breadcrumb ?? 'Browse sections';

    return Container(
      width: widget.vpWidth,
      height: isWide ? 72 : 58,
      decoration: BoxDecoration(color: LPColor.inkBlue_500.withOpacity(0.2)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Align(
          alignment: Alignment.centerLeft,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.article.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: body.apply(
                      const TextStyle(color: LPColor.gripperBlue_400),
                    ),
                  ),
                ),
                if (widget.sections.isNotEmpty)
                  Expanded(
                    child: Center(
                      child: PopupMenuButton<LPSectionEntry>(
                        tooltip: 'Jump to section',
                        onSelected: widget.onSectionSelected,
                        itemBuilder: (BuildContext context) {
                          return widget.sections
                              .map(
                                (LPSectionEntry section) =>
                                    PopupMenuItem<LPSectionEntry>(
                                      value: section,
                                      child: Text(
                                        section.breadcrumb,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: body2.apply(
                                          TextStyle(
                                            color:
                                                section == widget.currentSection
                                                ? LPColor.gripperBlue_500
                                                : LPColor.rollerBlue_500,
                                          ),
                                        ),
                                      ),
                                    ),
                              )
                              .toList();
                        },
                        child: SelectionContainer.disabled(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: LPColor.inkBlue_500.withOpacity(0.42),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: LPColor.rollerBlue_500.withOpacity(0.35),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: isWide ? 320 : 180,
                                  ),
                                  child: Text(
                                    sectionLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: body2.apply(
                                      const TextStyle(
                                        color: LPColor.gripperBlue_400,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.expand_more,
                                  size: 18,
                                  color: LPColor.gripperBlue_400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.article is LPPost)
                      LPButton(
                        width: isWide ? 54 : 42,
                        height: 32,
                        callback: () async {
                          final givenEmail = await showDialog<bool>(
                            context: context,
                            builder: (context) => EmailSubscriptionDialog(
                              isSubscribed: isSubscribedToPost,
                            ),
                          );
                          setState(() {
                            isSubscribedToPost =
                                (givenEmail != null && givenEmail == true)
                                ? true
                                : isSubscribedToPost;
                          });
                        },
                        child: Icon(
                          isSubscribedToPost
                              ? Icons.mark_email_read
                              : Icons.mail,
                          size: 22,
                          color: LPColor.rollerBlue_500,
                        ),
                      ),
                    if (widget.article is LPPost && showMeta)
                      const SizedBox(width: 16),
                    if (showMeta)
                      Text(
                        widget.article.lastUpdate.toDateString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: body.apply(
                          TextStyle(
                            color: LPColor.gripperBlue_400.withOpacity(0.4),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
