part of letterpress.ds;

enum SizeVariant { small, medium, large }

class PromoCard extends StatefulWidget {
  final LPArticle article;
  final String description;
  final SizeVariant size;
  final void Function() onTap;

  /// Ceiling on the card's height, when the space it sits in is bounded.
  ///
  /// Home page sections are a full viewport tall, so the carousel gets whatever
  /// the heading and blurb leave behind. Honouring that here is what keeps the
  /// cards inside the section instead of running off the bottom of it.
  final double? maxHeight;

  const PromoCard({
    required this.size,
    required this.article,
    required this.description,
    required this.onTap,
    this.maxHeight,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => PromoCardState();
}

class PromoCardState extends State<PromoCard> {
  bool hovering = false;
  bool pressing = false;

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    // Cards must never be wider than the viewport they scroll inside, or the
    // first card alone overflows the carousel on a narrow phone.
    final double maxCardWidth = vp.size.width - 40;

    final double cardWidth = math.min(
      maxCardWidth,
      switch (widget.size) {
        SizeVariant.small => vp.pick(mobile: 340.0, desktop: 438.0),
        SizeVariant.medium => vp.pick(mobile: 400.0, desktop: 600.0),
        SizeVariant.large => vp.pick(mobile: 440.0, desktop: 776.0),
      },
    );

    final double preferredHeight = switch (widget.size) {
      SizeVariant.small => vp.pick(mobile: 380.0, desktop: 450.0),
      SizeVariant.medium => vp.pick(mobile: 380.0, desktop: 450.0),
      SizeVariant.large => vp.pick(mobile: 400.0, desktop: 520.0),
    };
    final double cardHeight = widget.maxHeight == null
        ? preferredHeight
        : math.min(preferredHeight, widget.maxHeight!);

    return Center(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => hovering = true),
        onExit: (_) => setState(() => hovering = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() {
            if (!widget.article.isPreviewMode) {
              pressing = true;
            }
          }),
          onTapUp: (_) => setState(() {
            if (!widget.article.isPreviewMode) {
              pressing = false;
              widget.onTap();
            }
          }),
          child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: LPColor.inkBlue_500,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: pressing ? LPColor.chaseRed_500 : LPColor.rollerBlue_500,
              ),
              boxShadow: hovering
                  ? [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        color: (pressing ? LPColor.chaseRed_500 : Colors.black)
                            .withOpacity(0.3),
                        blurRadius: 13,
                        spreadRadius: 4,
                      )
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  // Flexible, because a short section leaves the card less room
                  // than its title wants; ellipsis is better than an overflow.
                  Flexible(
                    child: Text(
                      widget.article.title,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: (switch (widget.size) {
                        SizeVariant.small => mediumFunky,
                        SizeVariant.medium => bigFunky,
                        SizeVariant.large => bigFunky,
                      }).apply(
                          const TextStyle(color: LPColor.gripperBlue_500)),
                    ),
                  ),
                  const Spacer(flex: 1),
                  Text(
                    widget.description,
                    style: body
                        .apply(const TextStyle(color: LPColor.rollerBlue_500)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
