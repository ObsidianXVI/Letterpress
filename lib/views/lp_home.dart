part of letterpress.views;

class LetterpressApp extends StatefulWidget {
  const LetterpressApp({super.key});

  @override
  State<StatefulWidget> createState() => LetterpressAppState();
}

class LetterpressAppState extends State<LetterpressApp> {
  final ScrollController postCarouselController = ScrollController();
  final ScrollController bloguleCarouselController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // A slow drift across the carousel on arrival, hinting that there is more
      // to the side. Guarded because a short list may not overflow at all, in
      // which case there is nothing to scroll and no client attached.
      for (final ScrollController controller in [
        postCarouselController,
        bloguleCarouselController,
      ]) {
        if (!controller.hasClients) continue;
        if (controller.position.maxScrollExtent <= 0) continue;
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(seconds: 15),
          curve: Curves.linear,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    postCarouselController.dispose();
    bloguleCarouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    return Material(
      color: LPColor.platenWhite_500,
      child: LPSelectionArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The masthead: a full-bleed title and nothing else.
              SizedBox(
                width: vp.size.width,
                height: vp.size.height,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: vp.pick(mobile: 0, desktop: 10),
                    left: vp.pick(mobile: 0, desktop: 10),
                  ),
                  child: Text(
                    'LET\nTER\nPRESS',
                    style: heroTitle.apply(),
                  ),
                ),
              ),
              const _AboutSection(),
              _DiscoverSection(
                controller: postCarouselController,
                itemBuilder: (double? maxHeight) => [
                  for (final post in LPStore.posts)
                    PromoCard(
                      size: SizeVariant.large,
                      article: post,
                      description: post.description,
                      maxHeight: maxHeight,
                      onTap: () => Navigator.pushNamed(
                        context,
                        "${LPRoutes.lp_posts}/${post.title.urlSafeSlug}",
                      ),
                    ),
                ],
              ),
              _HomeSection(
                title: 'Blogules',
                child: _CarouselSection(
                  blurb:
                      "Musings, insights, and personal experiences in byte-sized reads.",
                  controller: bloguleCarouselController,
                  itemBuilder: (double? maxHeight) => [
                    for (final blogule in LPStore.blogules)
                      PromoCard(
                        size: SizeVariant.medium,
                        article: blogule,
                        description: blogule.isPreviewMode
                            ? "COMING SOON"
                            : blogule.publicationDate.toDateString(),
                        maxHeight: maxHeight,
                        onTap: () => Navigator.of(context).pushNamed(
                          "${LPRoutes.lp_blogules}/${blogule.title.urlSafeSlug}",
                        ),
                      ),
                  ],
                ),
              ),
              _HomeSection(
                title: 'Newsletters',
                child: const _SectionBlurb(
                  text:
                      "We are a society strangling in unnecessary words, circular constructions, pompous frills and meaningless jargon. — William Zinsser",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Proportions taken from the `About - new` Figma frame (node 1:17), which is
/// drawn at 1280x832.
///
/// They are kept as fractions of the frame rather than pixel constants so the
/// composition — where the artwork edge falls, how far the caption sits from
/// it — survives at viewport sizes the design was never drawn at.
class _AboutMetrics {
  const _AboutMetrics._();

  static const double frameWidth = 1280;
  static const double frameHeight = 832;

  /// The artwork is flush to the right edge and bleeds the full height.
  static const double imageWidth = 588 / frameWidth;
  static const double padLeft = 70 / frameWidth;
  static const double padTop = 70 / frameHeight;

  /// Separates the caption from the artwork, and the caption from the floor.
  static const double gutter = 25 / frameWidth;
  static const double bodyWidth = 485 / frameWidth;
  static const double titleToBody = 50 / frameHeight;
}

/// The About band: copy on the left, Friedrich's *Woman at a Window* bleeding
/// off the right edge at full height.
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  static const String copy =
      """Letterpress is a blog about coding, design, SWE, and all that good stuff. I started this initially to document my reflections and knowledge as I worked on various projects.

It includes short-form Blogules, in-depth Posts, and even newsletters. I do not claim to be a professional coder or prolific writer, but in a sea full of vessels out on different voyages, this is the logbook of a particular one.""";

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final Size size = vp.size;

    final Widget textColumn = Padding(
      padding: EdgeInsets.only(
        left: size.width * _AboutMetrics.padLeft,
        right: size.width * _AboutMetrics.gutter,
        top: size.height * _AboutMetrics.padTop,
        bottom: size.width * _AboutMetrics.gutter,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: sectionTitle.apply(
              const TextStyle(color: LPColor.rollerBlue_500),
            ),
          ),
          SizedBox(height: size.height * _AboutMetrics.titleToBody),
          SizedBox(
            width: vp.pick(
              mobile: double.infinity,
              desktop: size.width * _AboutMetrics.bodyWidth,
            ),
            child: Text(
              copy,
              style: body.apply(
                const TextStyle(color: LPColor.gripperBlue_500),
              ),
            ),
          ),
          const Spacer(),
          // The credit is right-aligned so it runs up to the artwork's edge.
          const Align(
            alignment: Alignment.centerRight,
            child: LPArtworkCaption(),
          ),
        ],
      ),
    );

    final Widget artwork = Image.asset(
      'assets/images/artworks/WomanAtAWindow.jpg',
      fit: BoxFit.cover,
      // The source is 3072x4345, the same 0.707 ratio as the 588x832 box the
      // design places it in, so cover crops nothing at the intended width.
      alignment: Alignment.center,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );

    return SizedBox(
      width: size.width,
      height: size.height,
      child: ColoredBox(
        color: LPColor.inkBlue_500,
        child: vp.isDesktop
            ? Row(
                children: [
                  Expanded(
                    flex: ((1 - _AboutMetrics.imageWidth) * 1000).round(),
                    child: textColumn,
                  ),
                  Expanded(
                    flex: (_AboutMetrics.imageWidth * 1000).round(),
                    child: SizedBox.expand(child: artwork),
                  ),
                ],
              )
            // Portrait cannot take the side-by-side split, and stacking the two
            // does not work either: dividing the height between them leaves the
            // copy too little room, and how little depends on how the paragraphs
            // reflow — a 320px phone needs half again as many lines as a 390px
            // one. Running the artwork full-bleed behind the copy gives the text
            // the whole viewport regardless, and the scrim keeps it legible
            // while leaving the painting's lower half in the clear.
            : Stack(
                fit: StackFit.expand,
                children: [
                  // A phone is narrower than the painting's 0.707 ratio, so
                  // cover crops the sides and keeps the full height — the
                  // window stays in frame, which is what the section is about.
                  SizedBox.expand(child: artwork),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFA1D3557),
                          Color(0xEB1D3557),
                          Color(0x001D3557),
                          Color(0x8C1D3557),
                        ],
                        stops: [0.0, 0.42, 0.72, 1.0],
                      ),
                    ),
                    child: SizedBox.expand(),
                  ),
                  textColumn,
                ],
              ),
      ),
    );
  }
}

/// Proportions taken from the `Discover - new` Figma frame (node 93:16),
/// drawn on the same 1280x832 canvas as the About band.
class _DiscoverMetrics {
  const _DiscoverMetrics._();

  /// Title baseline block runs 70..164; the cards begin at 264.
  static const double titleToCards = 100 / _AboutMetrics.frameHeight;
  static const double cardGap = 46 / _AboutMetrics.frameWidth;
}

/// The Discover band, on the platen white ground the design calls for.
///
/// The artwork credit is carried over from the About frame at the identical
/// position. That is deliberate rather than a stray copy: the transition zooms
/// into the painting's white region until it becomes this section's background,
/// and the credit staying put is what stitches the two together.
class _DiscoverSection extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> Function(double? maxHeight) itemBuilder;

  const _DiscoverSection({
    required this.controller,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final Size size = vp.size;

    final double padLeft = size.width * _AboutMetrics.padLeft;
    final double padTop = size.height * _AboutMetrics.padTop;
    final double gutter = size.width * _AboutMetrics.gutter;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: ColoredBox(
        color: LPColor.platenWhite_500,
        child: Stack(
          children: [
            Padding(
              // No right padding: the cards are meant to run off the edge, so
              // the carousel reads as continuing past the viewport.
              padding: EdgeInsets.only(
                left: padLeft,
                top: padTop,
                // Clears the credit sitting at the foot of the band.
                bottom: gutter * 2 + size.height * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover',
                    style: sectionTitle.apply(
                      const TextStyle(color: LPColor.rollerBlue_500),
                    ),
                  ),
                  SizedBox(
                    height: size.height *
                        vp.pick(
                          mobile: 0.04,
                          desktop: _DiscoverMetrics.titleToCards,
                        ),
                  ),
                  Expanded(
                    child: _Carousel(
                      controller: controller,
                      itemBuilder: itemBuilder,
                      gap: size.width *
                          vp.pick(
                            mobile: 0.05,
                            desktop: _DiscoverMetrics.cardGap,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              // Right edge lands exactly where it does in the About band, which
              // is where the artwork's left edge was.
              right: vp.pick(
                mobile: padLeft,
                desktop:
                    size.width * (_AboutMetrics.imageWidth + _AboutMetrics.gutter),
              ),
              bottom: gutter,
              child: const LPArtworkCaption(),
            ),
          ],
        ),
      ),
    );
  }
}

/// A titled band on the home page, one full viewport tall and wide.
///
/// The section title is set in very large display type, so the space left for
/// the content beneath it varies a lot with the window. [child] is given that
/// remainder through an [Expanded] rather than a fixed height, which is what
/// keeps tall content — the card carousels especially — inside the section
/// instead of running off the bottom of it.
class _HomeSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _HomeSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    return Container(
      width: vp.size.width,
      height: vp.size.height,
      color: LPColor.inkBlue_500,
      padding: EdgeInsets.only(
        left: vp.pick(mobile: scaled(20, 16), desktop: scaled(60, 30)),
        right: vp.pick(mobile: scaled(24, 24), desktop: scaled(60, 30)),
        top: vp.pick(mobile: scaled(30, 24), desktop: scaled(60, 30)),
        bottom: vp.pick(mobile: scaled(30, 24), desktop: scaled(50, 30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: sectionTitle.apply(
              const TextStyle(color: LPColor.rollerBlue_500),
            ),
          ),
          // Section titles are set with a 0.76 line height, so descenders sit
          // below the text box and crowd whatever follows. The gap has to clear
          // the glyphs, not just the box.
          SizedBox(height: vp.pick(mobile: 26, desktop: 52)),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Standing text under a section title.
class _SectionBlurb extends StatelessWidget {
  static const double maxWidth = 600;

  final String text;

  const _SectionBlurb({required this.text});

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    return SizedBox(
      // A maximum, not a fixed size: a fixed width overflows narrow viewports.
      width: math.min(
          maxWidth, vp.size.width * vp.pick(mobile: 0.89, desktop: 0.8)),
      child: Text(
        text,
        style: body.apply(const TextStyle(color: LPColor.gripperBlue_400)),
      ),
    );
  }
}

/// A blurb followed by a horizontally scrolling row of promo cards.
///
/// The cards take whatever vertical space the blurb leaves, so the whole thing
/// fits the section it was given.
class _CarouselSection extends StatelessWidget {
  final String blurb;
  final ScrollController controller;
  final List<Widget> Function(double? maxHeight) itemBuilder;

  const _CarouselSection({
    required this.blurb,
    required this.controller,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionBlurb(text: blurb),
        SizedBox(height: vp.pick(mobile: 20, desktop: 40)),
        Expanded(
          child: _Carousel(controller: controller, itemBuilder: itemBuilder),
        ),
      ],
    );
  }
}

/// Horizontally scrolling row of promo cards.
class _Carousel extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> Function(double? maxHeight) itemBuilder;

  /// Space between cards. Defaults to the general home-page rhythm; Discover
  /// overrides it with the value from its Figma frame.
  final double? gap;

  const _Carousel({
    required this.controller,
    required this.itemBuilder,
    this.gap,
  });

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);
    final double gap = this.gap ?? vp.pick(mobile: 20, desktop: 40);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Passing the available height down lets each card cap itself, rather
        // than overflowing a section that turned out to be shorter than the
        // card's preferred size.
        final List<Widget> items = itemBuilder(
          constraints.hasBoundedHeight ? constraints.maxHeight : null,
        );

        return SingleChildScrollView(
          controller: controller,
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < items.length; i++) ...[
                items[i],
                if (i != items.length - 1) SizedBox(width: gap),
              ],
            ],
          ),
        );
      },
    );
  }
}
